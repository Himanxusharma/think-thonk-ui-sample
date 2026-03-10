'use client'

import { X, BookmarkIcon, Heart, Share2, Flame } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'

interface ContentItem {
  id: number
  category: string
  headline: string
  content: string
  expandedContent: string
  saved?: boolean
  liked?: boolean
  shared?: boolean
  streak?: number
}

interface FullscreenContentProps {
  content: ContentItem[]
  initialIndex: number
  onClose: () => void
  onSave: (id: number) => void
  onLike: (id: number) => void
  onShare: (id: number) => void
  streak: number
}

export default function FullscreenContent({
  content,
  initialIndex,
  onClose,
  onSave,
  onLike,
  onShare,
  streak,
}: FullscreenContentProps) {
  const scrollContainerRef = useRef<HTMLDivElement>(null)
  const [currentIndex, setCurrentIndex] = useState(initialIndex)
  const lastScrollRef = useRef(0)

  useEffect(() => {
    document.body.style.overflow = 'hidden'
    return () => {
      document.body.style.overflow = 'unset'
    }
  }, [])

  useEffect(() => {
    const scrollContainer = scrollContainerRef.current
    if (!scrollContainer) return

    const handleScroll = () => {
      const currentScroll = scrollContainer.scrollTop
      const scrollDelta = currentScroll - lastScrollRef.current
      const clientHeight = scrollContainer.clientHeight
      const currentPage = Math.round(currentScroll / clientHeight)

      setCurrentIndex(currentPage)
      lastScrollRef.current = currentScroll

      // Auto-scroll to next/previous page when near a snap point
      const scrollHeight = scrollContainer.scrollHeight
      const snapPoint = currentPage * clientHeight
      const nextSnapPoint = (currentPage + 1) * clientHeight

      if (
        Math.abs(currentScroll - snapPoint) < 50 &&
        Math.abs(scrollDelta) < 5 &&
        currentScroll > 0
      ) {
        if (nextSnapPoint < scrollHeight) {
          scrollContainer.scrollTo({
            top: nextSnapPoint,
            behavior: 'smooth',
          })
        }
      }
    }

    scrollContainer.addEventListener('scroll', handleScroll, { passive: true })
    return () => scrollContainer.removeEventListener('scroll', handleScroll)
  }, [])

  const handleKeyDown = (e: KeyboardEvent) => {
    if (e.key === 'Escape') onClose()
  }

  useEffect(() => {
    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [])

  return (
    <div className="fixed inset-0 z-50 bg-background flex flex-col">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-background border-b border-border">
        <div className="h-16 flex items-center justify-between px-4 sm:px-6">
          {/* Streak Display */}
          <div className="flex items-center gap-2">
            <Flame className="w-5 h-5 text-orange-500" />
            <span className="text-sm font-semibold">{streak}</span>
          </div>

          {/* Action Buttons */}
          <div className="flex items-center justify-end gap-4 sm:gap-6">
            {/* Save Button */}
            <button
              onClick={() => onSave(content[currentIndex].id)}
              className="flex items-center gap-1 group p-2"
              aria-label="Save article"
            >
              <BookmarkIcon
                size={20}
                className={`transition-all ${
                  content[currentIndex].saved
                    ? 'fill-foreground text-foreground'
                    : 'text-muted-foreground group-hover:text-foreground'
                }`}
              />
            </button>

            {/* Like Button */}
            <button
              onClick={() => onLike(content[currentIndex].id)}
              className="flex items-center gap-1 group p-2"
              aria-label="Like article"
            >
              <Heart
                size={20}
                className={`transition-all ${
                  content[currentIndex].liked
                    ? 'fill-foreground text-foreground'
                    : 'text-muted-foreground group-hover:text-foreground'
                }`}
              />
            </button>

            {/* Share Button */}
            <button
              onClick={() => onShare(content[currentIndex].id)}
              className="flex items-center gap-1 group p-2"
              aria-label="Share article"
            >
              <Share2
                size={20}
                className="text-muted-foreground group-hover:text-foreground transition-colors"
              />
            </button>

            {/* Close Button */}
            <button
              onClick={onClose}
              className="p-2 rounded-lg hover:bg-muted transition-colors"
              aria-label="Close fullscreen"
            >
              <X size={24} />
            </button>
          </div>
        </div>
      </div>

      {/* Content Scroll Area */}
      <div
        ref={scrollContainerRef}
        className="flex-1 overflow-y-scroll snap-y snap-mandatory"
      >
        {content.map((item, index) => (
          <div
            key={item.id}
            className="snap-start h-screen w-full flex items-center justify-center"
          >
            <div className="w-full h-full max-w-2xl mx-auto px-4 sm:px-6 py-12 flex flex-col justify-center overflow-y-auto">
              {/* Category */}
              <div className="inline-flex mb-8">
                <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                  {item.category}
                </span>
              </div>

              {/* Headline */}
              <h1 className="text-5xl md:text-6xl font-bold text-foreground mb-8 leading-tight">
                {item.headline}
              </h1>

              {/* Expanded Content */}
              <div className="prose prose-invert max-w-none space-y-6">
                {item.expandedContent.split('\n\n').map((paragraph, pIndex) => (
                  <div key={pIndex}>
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

              {/* End/Start Indicator */}
              {index === content.length - 1 && (
                <div className="mt-12 pt-8 border-t border-border flex flex-col items-center gap-4">
                  <p className="text-sm text-muted-foreground font-medium">
                    You've reached the end
                  </p>
                  <p className="text-xs text-muted-foreground">
                    Scroll up to view previous content
                  </p>
                </div>
              )}

              {index === 0 && currentIndex === 0 && (
                <div className="mt-12 pt-8 border-t border-border flex flex-col items-center gap-4">
                  <p className="text-sm text-muted-foreground font-medium">
                    Beginning of content
                  </p>
                  <p className="text-xs text-muted-foreground">
                    Scroll down to explore more
                  </p>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
