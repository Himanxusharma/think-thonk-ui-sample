'use client'

import { X } from 'lucide-react'
import { useEffect } from 'react'

interface ContentItem {
  id: number
  category: string
  headline: string
  content: string
  expandedContent: string
  saved?: boolean
  liked?: boolean
  shared?: boolean
}

interface ExpandedModalProps {
  isOpen: boolean
  onClose: () => void
  content: ContentItem
}

export default function ExpandedModal({
  isOpen,
  onClose,
  content,
}: ExpandedModalProps) {
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose()
    }
    if (isOpen) {
      document.addEventListener('keydown', handleEscape)
      document.body.style.overflow = 'hidden'
    }
    return () => {
      document.removeEventListener('keydown', handleEscape)
      document.body.style.overflow = 'unset'
    }
  }, [isOpen, onClose])

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 z-50 bg-background/95 backdrop-blur-sm overflow-y-auto">
      {/* Close Button */}
      <div className="sticky top-0 z-10 flex justify-end p-6 bg-background/80 backdrop-blur-sm border-b border-border">
        <button
          onClick={onClose}
          className="text-muted-foreground hover:text-foreground transition-colors"
        >
          <X size={28} />
        </button>
      </div>

      {/* Content */}
      <div className="max-w-2xl mx-auto px-6 py-12">
        {/* Category */}
        <div className="inline-flex mb-8">
          <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
            {content.category}
          </span>
        </div>

        {/* Headline */}
        <h1 className="text-5xl md:text-6xl font-bold text-foreground mb-8 leading-tight">
          {content.headline}
        </h1>

        {/* Expanded Content */}
        <div className="prose prose-invert max-w-none space-y-6">
          {content.expandedContent.split('\n\n').map((paragraph, index) => (
            <div key={index}>
              {paragraph.includes(':') ? (
                // Handle sections with colons
                <div>
                  <p className="text-lg text-foreground/80 leading-relaxed font-semibold mb-4">
                    {paragraph.split(':')[0]}:
                  </p>
                  {paragraph.includes('•') ? (
                    <ul className="space-y-3 ml-4">
                      {paragraph
                        .split('\n')
                        .filter(line => line.trim().startsWith('•'))
                        .map((line, i) => (
                          <li
                            key={i}
                            className="text-base md:text-lg text-foreground/75 leading-relaxed list-disc ml-4"
                          >
                            {line.replace('•', '').trim()}
                          </li>
                        ))}
                    </ul>
                  ) : null}
                </div>
              ) : (
                // Regular paragraphs
                <p className="text-base md:text-lg text-foreground/80 leading-relaxed">
                  {paragraph}
                </p>
              )}
            </div>
          ))}
        </div>

        {/* Spacer */}
        <div className="h-12" />
      </div>
    </div>
  )
}
