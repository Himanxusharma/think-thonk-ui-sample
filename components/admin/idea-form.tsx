'use client'

import { useState } from 'react'
import { AlertCircle, Loader2 } from 'lucide-react'
import {
  AdminIdeaInput,
  IdeaFormMode,
  IdeaStatus,
  AdminActionResponse,
  Idea,
} from '@/lib/models/content_model'
import {
  validateIdeaInput,
  parseJSONInput,
  ideaInputToJSON,
  createIdea,
} from '@/lib/services/admin_service'
import FormToggle from './form-toggle'
import FieldsEditor from './fields-editor'
import JSONEditor from './json-editor'

interface IdeaFormProps {
  onSuccess?: (idea: Idea) => void
  onError?: (error: string) => void
}

const defaultInput: AdminIdeaInput = {
  category: '',
  title: '',
  explanation: '',
  example: '',
  takeaway: '',
  customHeading: '',
  customContent: '',
  status: IdeaStatus.DRAFT,
}

export default function IdeaForm({ onSuccess, onError }: IdeaFormProps) {
  const [mode, setMode] = useState<IdeaFormMode>(IdeaFormMode.FIELDS)
  const [input, setInput] = useState<AdminIdeaInput>(defaultInput)
  const [jsonString, setJsonString] = useState(ideaInputToJSON(defaultInput))
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [isLoading, setIsLoading] = useState(false)
  const [submitError, setSubmitError] = useState<string>('')
  const [successMessage, setSuccessMessage] = useState<string>('')

  // Handle mode switching with data preservation
  const handleModeChange = (newMode: IdeaFormMode) => {
    setMode(newMode)
    setSubmitError('')
    setSuccessMessage('')

    if (newMode === IdeaFormMode.JSON) {
      // Convert current input to JSON
      setJsonString(ideaInputToJSON(input))
    }
  }

  // Handle fields editor changes
  const handleInputChange = (newInput: AdminIdeaInput) => {
    setInput(newInput)
    setErrors({})
    setSubmitError('')

    // Also update JSON representation
    setJsonString(ideaInputToJSON(newInput))
  }

  // Handle JSON editor changes
  const handleJsonChange = (json: string) => {
    setJsonString(json)
    setSubmitError('')
  }

  // Handle JSON parsing
  const handleJsonParsed = (parsedInput: AdminIdeaInput | null) => {
    if (parsedInput) {
      setInput(parsedInput)
      setErrors({})
    }
  }

  // Validate and submit
  const handleSubmit = async (e: React.FormEvent, publishImmediately: boolean) => {
    e.preventDefault()
    setIsLoading(true)
    setSubmitError('')
    setSuccessMessage('')

    try {
      // Validate input based on current mode
      let finalInput = input

      if (mode === IdeaFormMode.JSON) {
        // Parse and validate JSON
        const parseResult = parseJSONInput(jsonString)
        if (!parseResult.success) {
          setSubmitError(parseResult.error || 'Failed to parse JSON')
          setIsLoading(false)
          return
        }
        finalInput = parseResult.data!
      }

      // Set status based on button clicked
      finalInput = {
        ...finalInput,
        status: publishImmediately ? IdeaStatus.PUBLISHED : IdeaStatus.DRAFT,
      }

      // Final validation
      const validationErrors = validateIdeaInput(finalInput)
      if (validationErrors.length > 0) {
        const errorMap: Record<string, string> = {}
        validationErrors.forEach((err) => {
          errorMap[err.field] = err.message
        })
        setErrors(errorMap)
        setIsLoading(false)
        return
      }

      // Create the idea
      const response = await createIdea(
        finalInput,
        'user_123', // TODO: Replace with actual user ID
      )

      if (response.success && response.data) {
        setSuccessMessage(
          publishImmediately
            ? '✓ Idea published successfully!'
            : '✓ Draft saved successfully!',
        )
        setInput(defaultInput)
        setJsonString(ideaInputToJSON(defaultInput))
        setErrors({})

        // Call success callback
        if (onSuccess) {
          onSuccess(response.data)
        }

        // Clear success message after 3 seconds
        setTimeout(() => setSuccessMessage(''), 3000)
      } else {
        setSubmitError(response.error || 'Failed to save idea')
        if (onError) {
          onError(response.error || 'Failed to save idea')
        }
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : 'An error occurred'
      setSubmitError(message)
      if (onError) {
        onError(message)
      }
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <form className="space-y-6">
      {/* Form Mode Toggle */}
      <FormToggle mode={mode} onModeChange={handleModeChange} />

      {/* Conditional Editor */}
      {mode === IdeaFormMode.FIELDS ? (
        <FieldsEditor
          input={input}
          onChange={handleInputChange}
          errors={errors}
        />
      ) : (
        <JSONEditor
          jsonString={jsonString}
          onJsonChange={handleJsonChange}
          onInputParsed={handleJsonParsed}
          error={submitError}
        />
      )}

      {/* Error Alert */}
      {submitError && (
        <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-4 flex gap-3">
          <AlertCircle className="w-5 h-5 text-red-500 flex-shrink-0 mt-0.5" />
          <div>
            <p className="text-sm font-medium text-red-600">{submitError}</p>
          </div>
        </div>
      )}

      {/* Success Alert */}
      {successMessage && (
        <div className="bg-green-500/10 border border-green-500/20 rounded-lg p-4">
          <p className="text-sm text-green-600 font-medium">{successMessage}</p>
        </div>
      )}

      {/* Action Buttons */}
      <div className="flex gap-3 pt-6 border-t border-border">
        <button
          onClick={(e) => handleSubmit(e, false)}
          disabled={isLoading}
          className="flex-1 flex items-center justify-center gap-2 bg-muted hover:bg-muted/80 text-foreground font-medium py-2.5 rounded-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isLoading && <Loader2 className="w-4 h-4 animate-spin" />}
          Save as Draft
        </button>

        <button
          onClick={(e) => handleSubmit(e, true)}
          disabled={isLoading}
          className="flex-1 flex items-center justify-center gap-2 bg-primary hover:bg-primary/90 text-primary-foreground font-medium py-2.5 rounded-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isLoading && <Loader2 className="w-4 h-4 animate-spin" />}
          Publish Now
        </button>
      </div>
    </form>
  )
}
