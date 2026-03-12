'use client'

import { Code2, FileText } from 'lucide-react'
import { IdeaFormMode } from '@/lib/models/content_model'

interface FormToggleProps {
  mode: IdeaFormMode
  onModeChange: (mode: IdeaFormMode) => void
}

export default function FormToggle({ mode, onModeChange }: FormToggleProps) {
  return (
    <div className="flex gap-2 mb-6">
      <button
        onClick={() => onModeChange(IdeaFormMode.FIELDS)}
        className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
          mode === IdeaFormMode.FIELDS
            ? 'bg-primary text-primary-foreground'
            : 'bg-muted text-muted-foreground hover:bg-muted/80'
        }`}
      >
        <FileText className="w-4 h-4" />
        Input Fields
      </button>

      <button
        onClick={() => onModeChange(IdeaFormMode.JSON)}
        className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
          mode === IdeaFormMode.JSON
            ? 'bg-primary text-primary-foreground'
            : 'bg-muted text-muted-foreground hover:bg-muted/80'
        }`}
      >
        <Code2 className="w-4 h-4" />
        JSON Mode
      </button>
    </div>
  )
}
