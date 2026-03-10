'use client'

import { BookmarkIcon, Heart, Share2, Maximize2 } from 'lucide-react'
import { Button } from '@/components/ui/button'

interface ContentItem {
  id: number
  category: string
  headline: string
  content: string
  expandedContent?: string
  saved?: boolean
  liked?: boolean
  shared?: boolean
}

interface ContentCardProps {
  item: ContentItem
  onReadMore: () => void
  onSave: () => void
  onLike: () => void
  onShare: () => void
  onFullscreen: () => void
}

export default function ContentCard({
  item,
  onReadMore,
  onSave,
  onLike,
  onShare,
  onFullscreen,
}: ContentCardProps) {
  return (
    <div className="w-full h-full bg-background flex flex-col items-center justify-center px-4 sm:px-6 py-8 sm:py-12 relative">
      {/* Container */}
      <div className="w-full max-w-lg flex flex-col h-full justify-between relative">
        {/* Top Section - Content */}
        <div className="flex-1 flex flex-col justify-center gap-4 sm:gap-6">
          {/* Category Badge */}
          <div className="inline-flex w-fit">
            <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
              {item.category}
            </span>
          </div>

          {/* Headline - Two Lines */}
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-foreground leading-tight">
            {item.headline}
          </h1>

          {/* Content - 3-4 Lines */}
          <p className="text-sm sm:text-base lg:text-lg text-foreground/80 leading-relaxed line-clamp-4">
            {item.content}
          </p>

          {/* Read More and Expand Buttons */}
          <div className="flex items-center gap-6 mt-4">
            <button
              onClick={onReadMore}
              className="text-xs sm:text-sm font-medium text-foreground underline underline-offset-4 hover:text-muted-foreground transition-colors w-fit"
            >
              Read More →
            </button>
            <button
              onClick={onFullscreen}
              className="text-xs sm:text-sm font-medium text-foreground underline underline-offset-4 hover:text-muted-foreground transition-colors w-fit"
            >
              Fullscreen →
            </button>
          </div>
        </div>

        {/* Bottom Section - Action Buttons */}
        <div className="flex items-center justify-start gap-6 sm:gap-8 pt-8">
          {/* Save Button */}
          <button
            onClick={onSave}
            className="flex flex-col items-center gap-1 group"
            aria-label="Save article"
          >
            <BookmarkIcon
              size={24}
              className={`transition-all ${
                item.saved
                  ? 'fill-foreground text-foreground'
                  : 'text-muted-foreground group-hover:text-foreground'
              }`}
            />
            <span className="text-xs text-muted-foreground group-hover:text-foreground transition-colors">
              Save
            </span>
          </button>

          {/* Like Button */}
          <button
            onClick={onLike}
            className="flex flex-col items-center gap-1 group"
            aria-label="Like article"
          >
            <Heart
              size={24}
              className={`transition-all ${
                item.liked
                  ? 'fill-red-500 text-red-500'
                  : 'text-muted-foreground group-hover:text-foreground'
              }`}
            />
            <span className="text-xs text-muted-foreground group-hover:text-foreground transition-colors">
              Like
            </span>
          </button>

          {/* Share Button */}
          <button
            onClick={onShare}
            className="flex flex-col items-center gap-1 group"
            aria-label="Share article"
          >
            <Share2
              size={24}
              className="text-muted-foreground group-hover:text-foreground transition-colors"
            />
            <span className="text-xs text-muted-foreground group-hover:text-foreground transition-colors">
              Share
            </span>
          </button>
        </div>

        {/* Fullscreen Button - Bottom Right */}
        <button
          onClick={onFullscreen}
          className="absolute bottom-8 right-4 sm:right-6 p-3 rounded-lg bg-primary hover:bg-primary/90 transition-colors shadow-lg"
          aria-label="Fullscreen view"
        >
          <Maximize2 size={24} className="text-primary-foreground" />
        </button>
      </div>
    </div>
  )
}
