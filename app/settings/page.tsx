'use client'

import { useState } from 'react'
import { ArrowLeft, Moon, Sun, Bell, Lock, Database } from 'lucide-react'
import { useTheme } from 'next-themes'
import Link from 'next/link'

export default function SettingsPage() {
  const { theme, setTheme } = useTheme()
  const [settings, setSettings] = useState({
    notifications: true,
    emailDigest: false,
    privateProfile: false,
    showActivity: true,
  })

  const toggleSetting = (key: keyof typeof settings) => {
    setSettings((prev) => ({
      ...prev,
      [key]: !prev[key],
    }))
  }

  const SettingToggle = ({
    label,
    description,
    icon: Icon,
    value,
    onChange,
  }: {
    label: string
    description: string
    icon: React.ComponentType<{ className: string }>
    value: boolean
    onChange: () => void
  }) => (
    <div className="flex items-start justify-between py-4 border-b border-border last:border-b-0">
      <div className="flex items-start gap-3">
        <div className="p-2 rounded-lg bg-muted mt-1">
          <Icon className="w-5 h-5 text-foreground" />
        </div>
        <div>
          <p className="font-medium text-foreground">{label}</p>
          <p className="text-sm text-muted-foreground">{description}</p>
        </div>
      </div>
      <button
        onClick={onChange}
        className={`relative w-11 h-6 rounded-full transition-colors ${
          value ? 'bg-primary' : 'bg-muted'
        }`}
        role="switch"
        aria-checked={value}
      >
        <div
          className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform ${
            value ? 'translate-x-5' : ''
          }`}
        />
      </button>
    </div>
  )

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
          <h1 className="text-2xl font-bold">Settings</h1>
        </div>
      </div>

      {/* Settings Content */}
      <div className="max-w-2xl mx-auto px-4 py-8">
        {/* Theme Section */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          <h2 className="text-lg font-semibold text-foreground mb-4">Appearance</h2>

          <div className="flex items-center gap-3 mb-6">
            <p className="text-sm text-muted-foreground flex-1">Theme</p>
            <div className="flex gap-2">
              <button
                onClick={() => setTheme('light')}
                className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${
                  theme === 'light'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted hover:bg-muted/80'
                }`}
              >
                <Sun className="w-4 h-4" />
                <span className="text-sm font-medium">Light</span>
              </button>
              <button
                onClick={() => setTheme('dark')}
                className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${
                  theme === 'dark'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted hover:bg-muted/80'
                }`}
              >
                <Moon className="w-4 h-4" />
                <span className="text-sm font-medium">Dark</span>
              </button>
              <button
                onClick={() => setTheme('system')}
                className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${
                  theme === 'system'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted hover:bg-muted/80'
                }`}
              >
                <span className="text-sm font-medium">System</span>
              </button>
            </div>
          </div>
        </div>

        {/* Notifications Section */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          <h2 className="text-lg font-semibold text-foreground mb-4">
            Notifications
          </h2>

          <SettingToggle
            label="Push Notifications"
            description="Receive notifications about new articles and trending content"
            icon={Bell}
            value={settings.notifications}
            onChange={() => toggleSetting('notifications')}
          />

          <SettingToggle
            label="Email Digest"
            description="Weekly digest of articles in your interests"
            icon={Bell}
            value={settings.emailDigest}
            onChange={() => toggleSetting('emailDigest')}
          />
        </div>

        {/* Privacy Section */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          <h2 className="text-lg font-semibold text-foreground mb-4">Privacy</h2>

          <SettingToggle
            label="Private Profile"
            description="Only you can see your profile and activity"
            icon={Lock}
            value={settings.privateProfile}
            onChange={() => toggleSetting('privateProfile')}
          />

          <SettingToggle
            label="Show Activity Status"
            description="Let others see when you're reading articles"
            icon={Database}
            value={settings.showActivity}
            onChange={() => toggleSetting('showActivity')}
          />
        </div>

        {/* Data Section */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          <h2 className="text-lg font-semibold text-foreground mb-4">Data</h2>

          <button className="w-full flex items-center justify-between px-4 py-3 rounded-lg hover:bg-muted/50 transition-colors mb-2">
            <span className="text-sm font-medium text-foreground">
              Download Your Data
            </span>
            <span className="text-xs text-muted-foreground">
              Export all your data
            </span>
          </button>

          <button className="w-full flex items-center justify-between px-4 py-3 rounded-lg hover:bg-red-500/10 transition-colors text-red-500">
            <span className="text-sm font-medium">Delete Account</span>
            <span className="text-xs opacity-70">Permanently delete</span>
          </button>
        </div>

        {/* About Section */}
        <div className="bg-card border border-border rounded-lg p-6">
          <h2 className="text-lg font-semibold text-foreground mb-4">About</h2>

          <div className="space-y-3">
            <div className="flex justify-between items-center py-2 border-b border-border last:border-b-0">
              <span className="text-sm text-muted-foreground">App Version</span>
              <span className="text-sm font-medium text-foreground">2.6.0</span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-border last:border-b-0">
              <span className="text-sm text-muted-foreground">Build</span>
              <span className="text-sm font-medium text-foreground">240310</span>
            </div>
            <div className="flex justify-between items-center py-2 border-b border-border last:border-b-0">
              <span className="text-sm text-muted-foreground">
                Last Updated
              </span>
              <span className="text-sm font-medium text-foreground">
                Mar 13, 2024
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
