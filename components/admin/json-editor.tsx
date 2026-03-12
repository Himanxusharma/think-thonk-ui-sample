'use client'

import { AlertCircle, Copy, Check } from 'lucide-react'
import { useState } from 'react'
import { AdminIdeaInput } from '@/lib/models/content_model'
import { parseJSONInput } from '@/lib/services/admin_service'

interface JSONEditorProps {
  jsonString: string
  onJsonChange: (json: string) => void
  onInputParsed: (input: AdminIdeaInput | null) => void
  error?: string
}

export default function JSONEditor({
  jsonString,
  onJsonChange,
  onInputParsed,
  error,
}: JSONEditorProps) {
  const [copied, setCopied] = useState(false)
  const [parseError, setParseError] = useState<string>('')

  const handleJsonChange = (value: string) => {
    onJsonChange(value)
    
    // Auto-validate while typing
    if (value.trim()) {
      const result = parseJSONInput(value)
      if (result.success && result.data) {
        setParseError('')
        onInputParsed(result.data)
      } else {
        setParseError(result.error || 'Invalid JSON')
        onInputParsed(null)
      }
    } else {
      setParseError('')
      onInputParsed(null)
    }
  }

  const handleCopy = () => {
    navigator.clipboard.writeText(jsonString)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  const handleFormat = () => {
    try {
      const parsed = JSON.parse(jsonString)
      onJsonChange(JSON.stringify(parsed, null, 2))
      setParseError('')
    } catch {
      setParseError('Invalid JSON format')
    }
  }

  return (
    <div className="space-y-4">
      {/* Info Box */}
      <div className="bg-blue-500/10 border border-blue-500/20 rounded-lg p-4">
        <p className="text-sm text-foreground">
          Enter a JSON object with the following fields: <code className="text-xs bg-background px-1 rounded">category</code>, <code className="text-xs bg-background px-1 rounded">title</code>, <code className="text-xs bg-background px-1 rounded">explanation</code>, <code className="text-xs bg-background px-1 rounded">example</code>, <code className="text-xs bg-background px-1 rounded">takeaway</code>, and optionally <code className="text-xs bg-background px-1 rounded">customHeading</code> and <code className="text-xs bg-background px-1 rounded">customContent</code>.
        </p>
      </div>

      {/* Editor Toolbar */}
      <div className="flex gap-2">
        <button
          onClick={handleFormat}
          className="px-3 py-2 text-sm bg-muted hover:bg-muted/80 rounded-lg transition-colors"
        >
          Format JSON
        </button>
        <button
          onClick={handleCopy}
          className="px-3 py-2 text-sm bg-muted hover:bg-muted/80 rounded-lg flex items-center gap-2 transition-colors"
        >
          {copied ? (
            <>
              <Check className="w-4 h-4 text-green-500" />
              Copied
            </>
          ) : (
            <>
              <Copy className="w-4 h-4" />
              Copy
            </>
          )}
        </button>
      </div>

      {/* JSON Editor */}
      <textarea
        value={jsonString}
        onChange={(e) => handleJsonChange(e.target.value)}
        placeholder={`{
  "category": "Psychology",
  "title": "Your Idea Title",
  "explanation": "Detailed explanation here...",
  "example": "Real-world example here...",
  "takeaway": "Key takeaway...",
  "customHeading": "Optional heading",
  "customContent": "Optional content",
  "status": "draft"
}`}
        className={`w-full h-96 bg-background border ${
          error || parseError
            ? 'border-red-500'
            : 'border-border'
        } rounded-lg px-4 py-3 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none transition-all`}
        spellCheck="false"
      />

      {/* Error Messages */}
      {(error || parseError) && (
        <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-4 flex gap-3">
          <AlertCircle className="w-5 h-5 text-red-500 flex-shrink-0 mt-0.5" />
          <div>
            <p className="text-sm font-medium text-red-600">
              {error || parseError}
            </p>
            {parseError && parseError !== 'Invalid JSON' && (
              <p className="text-xs text-red-500 mt-1">
                Check your JSON syntax and field names
              </p>
            )}
          </div>
        </div>
      )}

      {/* Success State */}
      {!error && !parseError && jsonString.trim() && (
        <div className="bg-green-500/10 border border-green-500/20 rounded-lg p-4">
          <p className="text-sm text-green-600 font-medium">
            ✓ JSON is valid and ready to publish
          </p>
        </div>
      )}
    </div>
  )
}
