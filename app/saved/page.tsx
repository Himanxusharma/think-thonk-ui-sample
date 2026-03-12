'use client'

import { useState } from 'react'
import { ArrowLeft, Bookmark, Trash2, Search } from 'lucide-react'
import Link from 'next/link'

interface SavedArticle {
  id: number
  category: string
  headline: string
  preview: string
  savedDate: string
}

export default function SavedPage() {
  const [searchQuery, setSearchQuery] = useState('')
  const [savedArticles, setSavedArticles] = useState<SavedArticle[]>([
    {
      id: 1,
      category: 'Psychology',
      headline: 'The Horse Effect Theory',
      preview:
        'Understanding how our brains process information through metaphorical thinking...',
      savedDate: 'March 10, 2024',
    },
    {
      id: 3,
      category: 'Behavioral Science',
      headline: 'The Paradox of Choice',
      preview:
        'How having too many options can lead to decision paralysis and decreased satisfaction...',
      savedDate: 'March 8, 2024',
    },
    {
      id: 5,
      category: 'Philosophy',
      headline: 'The Nature of Consciousness',
      preview:
        'Exploring the hard problem of consciousness and what it means to be aware...',
      savedDate: 'March 5, 2024',
    },
  ])

  const filteredArticles = savedArticles.filter(
    (article) =>
      article.headline.toLowerCase().includes(searchQuery.toLowerCase()) ||
      article.category.toLowerCase().includes(searchQuery.toLowerCase())
  )

  const handleRemove = (id: number) => {
    setSavedArticles(savedArticles.filter((article) => article.id !== id))
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="sticky top-0 bg-background/80 backdrop-blur-sm border-b border-border z-40">
        <div className="max-w-2xl mx-auto px-4 py-4 flex items-center gap-3">
          <Link
            href="/"
            className="p-2 rounded-lg hover:bg-muted transition-colors"
            aria-label="Go back"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <h1 className="text-2xl font-bold">Saved Articles</h1>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-2xl mx-auto px-4 py-8">
        {/* Search Bar */}
        <div className="mb-6">
          <div className="relative">
            <Search className="absolute left-3 top-3 w-5 h-5 text-muted-foreground" />
            <input
              type="text"
              placeholder="Search saved articles..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-card border border-border rounded-lg pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
            />
          </div>
        </div>

        {/* Articles List */}
        {filteredArticles.length > 0 ? (
          <div className="space-y-3">
            {filteredArticles.map((article) => (
              <div
                key={article.id}
                className="bg-card border border-border rounded-lg p-4 hover:bg-muted/50 transition-colors group"
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="text-xs font-medium text-primary bg-primary/10 px-2 py-1 rounded">
                        {article.category}
                      </span>
                      <span className="text-xs text-muted-foreground">
                        {article.savedDate}
                      </span>
                    </div>
                    <h3 className="font-semibold text-foreground mb-1 line-clamp-2">
                      {article.headline}
                    </h3>
                    <p className="text-sm text-muted-foreground line-clamp-2">
                      {article.preview}
                    </p>
                  </div>

                  <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button
                      onClick={() => handleRemove(article.id)}
                      className="p-2 rounded-lg hover:bg-red-500/10 transition-colors"
                      aria-label="Remove from saved"
                    >
                      <Trash2 className="w-4 h-4 text-red-500" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <div className="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-muted mb-4">
              <Bookmark className="w-6 h-6 text-muted-foreground" />
            </div>
            <h3 className="text-lg font-semibold text-foreground mb-1">
              {searchQuery ? 'No articles found' : 'No saved articles yet'}
            </h3>
            <p className="text-sm text-muted-foreground">
              {searchQuery
                ? 'Try a different search term'
                : 'Articles you save will appear here'}
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
