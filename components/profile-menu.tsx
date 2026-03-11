'use client'

import { useState, useRef, useEffect } from 'react'
import { User, Bookmark, Settings, LogOut } from 'lucide-react'

export default function ProfileMenu() {
  const [isOpen, setIsOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const menuItems = [
    { icon: User, label: 'Profile', href: '#profile' },
    { icon: Bookmark, label: 'Saved', href: '#saved' },
    { icon: Settings, label: 'Settings', href: '#settings' },
    { icon: LogOut, label: 'Logout', href: '#logout' },
  ]

  return (
    <div ref={menuRef} className="relative">
      {/* Profile Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="p-2 rounded-lg hover:bg-muted transition-colors"
        aria-label="Profile menu"
      >
        <User className="w-5 h-5" />
      </button>

      {/* Dropdown Menu */}
      {isOpen && (
        <div className="absolute right-0 mt-2 w-48 bg-card border border-border rounded-lg shadow-lg overflow-hidden z-50">
          {menuItems.map((item, index) => {
            const Icon = item.icon
            return (
              <a
                key={index}
                href={item.href}
                onClick={(e) => {
                  e.preventDefault()
                  setIsOpen(false)
                  // Handle menu item clicks here
                  console.log(`[v0] Clicked: ${item.label}`)
                }}
                className="flex items-center gap-3 px-4 py-3 hover:bg-muted transition-colors border-b border-border last:border-b-0 text-sm"
              >
                <Icon className="w-4 h-4" />
                <span>{item.label}</span>
              </a>
            )
          })}
        </div>
      )}
    </div>
  )
}
