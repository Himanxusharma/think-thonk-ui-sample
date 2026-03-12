'use client'

import {
  AdminIdeaInput,
  IdeaStatus,
  IDEA_CATEGORIES,
  IdeaValidationError,
} from '@/lib/models/content_model'

interface FieldsEditorProps {
  input: AdminIdeaInput
  onChange: (input: AdminIdeaInput) => void
  errors: Record<string, string>
}

export default function FieldsEditor({
  input,
  onChange,
  errors,
}: FieldsEditorProps) {
  const handleChange = (field: keyof AdminIdeaInput, value: any) => {
    onChange({
      ...input,
      [field]: value,
    })
  }

  const getFieldError = (field: keyof AdminIdeaInput): string | undefined => {
    return errors[field]
  }

  return (
    <div className="space-y-6">
      {/* Category */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Category
          <span className="text-red-500 ml-1">*</span>
        </label>
        <select
          value={input.category}
          onChange={(e) => handleChange('category', e.target.value)}
          className={`w-full bg-background border ${
            getFieldError('category')
              ? 'border-red-500'
              : 'border-border'
          } rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all`}
        >
          <option value="">Select a category</option>
          {IDEA_CATEGORIES.map((category) => (
            <option key={category} value={category}>
              {category}
            </option>
          ))}
        </select>
        {getFieldError('category') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('category')}</p>
        )}
      </div>

      {/* Title */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Title
          <span className="text-red-500 ml-1">*</span>
        </label>
        <input
          type="text"
          value={input.title}
          onChange={(e) => handleChange('title', e.target.value)}
          placeholder="Enter a compelling title"
          className={`w-full bg-background border ${
            getFieldError('title')
              ? 'border-red-500'
              : 'border-border'
          } rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all`}
        />
        {getFieldError('title') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('title')}</p>
        )}
      </div>

      {/* Explanation */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Explanation
          <span className="text-red-500 ml-1">*</span>
        </label>
        <textarea
          value={input.explanation}
          onChange={(e) => handleChange('explanation', e.target.value)}
          placeholder="Provide a detailed explanation of the concept"
          rows={4}
          className={`w-full bg-background border ${
            getFieldError('explanation')
              ? 'border-red-500'
              : 'border-border'
          } rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none transition-all`}
        />
        {getFieldError('explanation') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('explanation')}</p>
        )}
      </div>

      {/* Example */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Example
          <span className="text-red-500 ml-1">*</span>
        </label>
        <textarea
          value={input.example}
          onChange={(e) => handleChange('example', e.target.value)}
          placeholder="Provide a real-world or practical example"
          rows={3}
          className={`w-full bg-background border ${
            getFieldError('example')
              ? 'border-red-500'
              : 'border-border'
          } rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none transition-all`}
        />
        {getFieldError('example') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('example')}</p>
        )}
      </div>

      {/* Takeaway */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Key Takeaway
          <span className="text-red-500 ml-1">*</span>
        </label>
        <textarea
          value={input.takeaway}
          onChange={(e) => handleChange('takeaway', e.target.value)}
          placeholder="What should readers remember most?"
          rows={2}
          className={`w-full bg-background border ${
            getFieldError('takeaway')
              ? 'border-red-500'
              : 'border-border'
          } rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none transition-all`}
        />
        {getFieldError('takeaway') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('takeaway')}</p>
        )}
      </div>

      {/* Custom Heading (Optional) */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Custom Heading <span className="text-xs text-muted-foreground">(Optional)</span>
        </label>
        <input
          type="text"
          value={input.customHeading || ''}
          onChange={(e) => handleChange('customHeading', e.target.value || undefined)}
          placeholder="Additional section heading"
          className="w-full bg-background border border-border rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
        />
      </div>

      {/* Custom Content (Optional) */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Custom Content <span className="text-xs text-muted-foreground">(Optional)</span>
        </label>
        <textarea
          value={input.customContent || ''}
          onChange={(e) => handleChange('customContent', e.target.value || undefined)}
          placeholder="Additional custom content or notes"
          rows={3}
          className="w-full bg-background border border-border rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none transition-all"
        />
      </div>

      {/* Status */}
      <div>
        <label className="block text-sm font-medium text-foreground mb-2">
          Status
          <span className="text-red-500 ml-1">*</span>
        </label>
        <div className="flex gap-3">
          {Object.values(IdeaStatus).map((status) => (
            <label key={status} className="flex items-center gap-2">
              <input
                type="radio"
                name="status"
                value={status}
                checked={input.status === status}
                onChange={(e) => handleChange('status', e.target.value)}
                className="w-4 h-4 cursor-pointer"
              />
              <span className="text-sm capitalize">{status}</span>
            </label>
          ))}
        </div>
        {getFieldError('status') && (
          <p className="text-red-500 text-xs mt-1">{getFieldError('status')}</p>
        )}
      </div>
    </div>
  )
}
