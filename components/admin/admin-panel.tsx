'use client'

import { useState } from 'react'
import { Plus, CheckCircle2, AlertCircle } from 'lucide-react'
import { Idea } from '@/lib/models/content_model'
import IdeaForm from './idea-form'

interface AdminPanelProps {
  onIdeaCreated?: (idea: Idea) => void
}

export default function AdminPanel({ onIdeaCreated }: AdminPanelProps) {
  const [createdIdeas, setCreatedIdeas] = useState<Idea[]>([])
  const [showForm, setShowForm] = useState(false)

  const handleIdeaSuccess = (idea: Idea) => {
    setCreatedIdeas([idea, ...createdIdeas])
    if (onIdeaCreated) {
      onIdeaCreated(idea)
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Admin Dashboard</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Create and publish content ideas
          </p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
            showForm
              ? 'bg-red-500/10 text-red-500 hover:bg-red-500/20'
              : 'bg-primary text-primary-foreground hover:bg-primary/90'
          }`}
        >
          <Plus className="w-4 h-4" />
          {showForm ? 'Cancel' : 'New Idea'}
        </button>
      </div>

      {/* Form Section */}
      {showForm && (
        <div className="bg-card border border-border rounded-lg p-6">
          <h2 className="text-xl font-semibold text-foreground mb-6">
            Create New Idea
          </h2>
          <IdeaForm onSuccess={handleIdeaSuccess} />
        </div>
      )}

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-card border border-border rounded-lg p-4">
          <p className="text-sm text-muted-foreground uppercase tracking-wide font-medium mb-2">
            Total Ideas
          </p>
          <p className="text-3xl font-bold text-primary">{createdIdeas.length}</p>
        </div>
        <div className="bg-card border border-border rounded-lg p-4">
          <p className="text-sm text-muted-foreground uppercase tracking-wide font-medium mb-2">
            Published
          </p>
          <p className="text-3xl font-bold text-green-500">
            {createdIdeas.filter((idea) => idea.status === 'published').length}
          </p>
        </div>
        <div className="bg-card border border-border rounded-lg p-4">
          <p className="text-sm text-muted-foreground uppercase tracking-wide font-medium mb-2">
            Drafts
          </p>
          <p className="text-3xl font-bold text-yellow-500">
            {createdIdeas.filter((idea) => idea.status === 'draft').length}
          </p>
        </div>
      </div>

      {/* Recent Ideas List */}
      {createdIdeas.length > 0 && (
        <div className="bg-card border border-border rounded-lg overflow-hidden">
          <div className="px-6 py-4 border-b border-border">
            <h2 className="text-lg font-semibold text-foreground">
              Recent Ideas
            </h2>
          </div>

          <div className="divide-y divide-border">
            {createdIdeas.map((idea) => (
              <div key={idea.id} className="px-6 py-4 hover:bg-muted/30 transition-colors">
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h3 className="font-semibold text-foreground">
                        {idea.title}
                      </h3>
                      <span className={`text-xs font-medium px-2 py-0.5 rounded ${
                        idea.status === 'published'
                          ? 'bg-green-500/10 text-green-600'
                          : 'bg-yellow-500/10 text-yellow-600'
                      }`}>
                        {idea.status.charAt(0).toUpperCase() + idea.status.slice(1)}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground">
                      {idea.category} • {new Date(idea.createdOn).toLocaleDateString()}
                    </p>
                    <p className="text-sm text-foreground/80 mt-2 line-clamp-2">
                      {idea.explanation}
                    </p>
                  </div>

                  {idea.status === 'published' && (
                    <CheckCircle2 className="w-5 h-5 text-green-500 flex-shrink-0 mt-1" />
                  )}
                  {idea.status === 'draft' && (
                    <AlertCircle className="w-5 h-5 text-yellow-500 flex-shrink-0 mt-1" />
                  )}
                </div>

                {/* Engagement Stats */}
                {(idea.likesCount > 0 ||
                  idea.savesCount > 0 ||
                  idea.shareCount > 0) && (
                  <div className="flex gap-4 mt-3 text-xs text-muted-foreground">
                    {idea.likesCount > 0 && (
                      <span>❤️ {idea.likesCount} likes</span>
                    )}
                    {idea.savesCount > 0 && (
                      <span>🔖 {idea.savesCount} saves</span>
                    )}
                    {idea.shareCount > 0 && (
                      <span>📤 {idea.shareCount} shares</span>
                    )}
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Empty State */}
      {createdIdeas.length === 0 && !showForm && (
        <div className="bg-card border border-border rounded-lg p-8 text-center">
          <Plus className="w-8 h-8 text-muted-foreground mx-auto mb-3 opacity-50" />
          <p className="text-muted-foreground">
            No ideas created yet. Click "New Idea" to get started.
          </p>
        </div>
      )}
    </div>
  )
}
