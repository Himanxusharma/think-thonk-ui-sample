'use client'

import { useState } from 'react'
import { ArrowLeft, Mail, Calendar, MapPin, Edit2, LogOut } from 'lucide-react'
import Link from 'next/link'

export default function ProfilePage() {
  const [isEditing, setIsEditing] = useState(false)
  const [profile, setProfile] = useState({
    name: 'Demo User',
    email: 'demo@thinkthonk.com',
    bio: 'Passionate reader and thinker exploring ideas across psychology, science, and philosophy.',
    location: 'San Francisco, CA',
    joinDate: 'Jan 15, 2024',
  })
  const [editForm, setEditForm] = useState(profile)

  const handleSaveProfile = () => {
    setProfile(editForm)
    setIsEditing(false)
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
          <h1 className="text-2xl font-bold">Profile</h1>
        </div>
      </div>

      {/* Profile Content */}
      <div className="max-w-2xl mx-auto px-4 py-8">
        {/* Profile Card */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          {/* Avatar */}
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
                <span className="text-2xl font-bold text-primary">
                  {profile.name
                    .split(' ')
                    .map((n) => n[0])
                    .join('')}
                </span>
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{profile.name}</h2>
                <p className="text-sm text-muted-foreground">{profile.email}</p>
              </div>
            </div>
            {!isEditing && (
              <button
                onClick={() => setIsEditing(true)}
                className="p-2 rounded-lg hover:bg-muted transition-colors"
                aria-label="Edit profile"
              >
                <Edit2 className="w-5 h-5" />
              </button>
            )}
          </div>

          {/* Edit/View Form */}
          {isEditing ? (
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-foreground mb-1">
                  Full Name
                </label>
                <input
                  type="text"
                  value={editForm.name}
                  onChange={(e) =>
                    setEditForm({ ...editForm, name: e.target.value })
                  }
                  className="w-full bg-background border border-border rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-foreground mb-1">
                  Bio
                </label>
                <textarea
                  value={editForm.bio}
                  onChange={(e) =>
                    setEditForm({ ...editForm, bio: e.target.value })
                  }
                  rows={3}
                  className="w-full bg-background border border-border rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 resize-none"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-foreground mb-1">
                  Location
                </label>
                <input
                  type="text"
                  value={editForm.location}
                  onChange={(e) =>
                    setEditForm({ ...editForm, location: e.target.value })
                  }
                  className="w-full bg-background border border-border rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50"
                />
              </div>

              <div className="flex gap-2 pt-4">
                <button
                  onClick={handleSaveProfile}
                  className="flex-1 bg-primary hover:bg-primary/90 text-primary-foreground font-medium py-2 rounded-lg transition-colors"
                >
                  Save Changes
                </button>
                <button
                  onClick={() => {
                    setIsEditing(false)
                    setEditForm(profile)
                  }}
                  className="flex-1 bg-muted hover:bg-muted/80 text-foreground font-medium py-2 rounded-lg transition-colors"
                >
                  Cancel
                </button>
              </div>
            </div>
          ) : (
            <div className="space-y-4">
              <div>
                <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-1">
                  Bio
                </p>
                <p className="text-sm text-foreground">{profile.bio}</p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="flex items-center gap-2">
                  <MapPin className="w-4 h-4 text-muted-foreground" />
                  <div>
                    <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide">
                      Location
                    </p>
                    <p className="text-sm text-foreground">{profile.location}</p>
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-muted-foreground" />
                  <div>
                    <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide">
                      Joined
                    </p>
                    <p className="text-sm text-foreground">{profile.joinDate}</p>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-4 mb-6">
          <div className="bg-card border border-border rounded-lg p-4 text-center">
            <p className="text-2xl font-bold text-primary">145</p>
            <p className="text-xs text-muted-foreground mt-1">Articles Liked</p>
          </div>
          <div className="bg-card border border-border rounded-lg p-4 text-center">
            <p className="text-2xl font-bold text-primary">32</p>
            <p className="text-xs text-muted-foreground mt-1">Saved</p>
          </div>
          <div className="bg-card border border-border rounded-lg p-4 text-center">
            <p className="text-2xl font-bold text-orange-500">8</p>
            <p className="text-xs text-muted-foreground mt-1">Current Streak</p>
          </div>
        </div>

        {/* Logout Button */}
        <button className="w-full flex items-center justify-center gap-2 bg-red-500/10 hover:bg-red-500/20 text-red-500 font-medium py-2.5 rounded-lg transition-colors border border-red-500/20">
          <LogOut className="w-4 h-4" />
          Logout
        </button>
      </div>
    </div>
  )
}
