'use client'

import { BookmarkIcon, Heart, Share2 } from 'lucide-react'
import { Button } from '@/components/ui/button'

interface ContentItem {
  id: number
  category: string
  headline: string
  content: string
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
}

export default function ContentCard({
  item,
  onReadMore,
  onSave,
  onLike,
  onShare,
}: ContentCardProps) {
  return (
    <div className="w-full h-full bg-background flex flex-col items-center justify-center px-6 py-8">
      {/* Container */}
      <div className="w-full max-w-md flex flex-col h-full justify-between">
        {/* Top Section - Content */}
        <div className="flex-1 flex flex-col justify-center gap-6">
          {/* Category Badge */}
          <div className="inline-flex w-fit">
            <span className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
              {item.category}
            </span>
          </div>

          {/* Headline - Two Lines */}
          <h1 className="text-4xl md:text-5xl font-bold text-foreground leading-tight">
            {item.headline}
          </h1>

          {/* Content - 3-4 Lines */}
          <p className="text-base md:text-lg text-foreground/80 leading-relaxed line-clamp-4">
            {item.content}
          </p>

          {/* Read More Button */}
          <button
            onClick={onReadMore}
            className="mt-2 text-sm font-medium text-foreground underline underline-offset-4 hover:text-muted-foreground transition-colors w-fit"
          >
            Read More →
          </button>
        </div>

        {/* Bottom Section - Action Buttons */}
        <div className="flex items-center justify-start gap-6 pt-8">
          {/* Save Button */}
          <button
            onClick={onSave}
            className="flex flex-col items-center gap-1 group"
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
          >
            <Heart
              size={24}
              className={`transition-all ${
                item.liked
                  ? 'fill-foreground text-foreground'
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
      </div>
    </div>
  )
}
