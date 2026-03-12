'use client'

import { useState } from 'react'
import { Mail, Lock, User, Eye, EyeOff } from 'lucide-react'

export default function AuthPage() {
  const [isLogin, setIsLogin] = useState(true)
  const [showPassword, setShowPassword] = useState(false)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [name, setName] = useState('')
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const testCredentials = {
    email: 'demo@thinkthonk.com',
    password: 'Demo123!@#',
    name: 'Demo User',
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    if (isLogin) {
      if (email === testCredentials.email && password === testCredentials.password) {
        setSuccess('Login successful! Redirecting...')
        setTimeout(() => {
          window.location.href = '/'
        }, 1500)
      } else {
        setError('Invalid email or password. Try demo@thinkthonk.com / Demo123!@#')
      }
    } else {
      if (!name || !email || !password) {
        setError('Please fill in all fields')
        return
      }
      setSuccess('Account created! Redirecting to login...')
      setTimeout(() => {
        setIsLogin(true)
        setEmail('')
        setPassword('')
        setName('')
      }, 1500)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-12 bg-background">
      <div className="w-full max-w-md">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10 mb-4">
            <span className="text-lg font-bold text-primary">TT</span>
          </div>
          <h1 className="text-3xl font-bold text-foreground mb-2">Think Thonk</h1>
          <p className="text-sm text-muted-foreground">
            {isLogin ? 'Welcome back' : 'Join our community'}
          </p>
        </div>

        {/* Form Container */}
        <div className="bg-card border border-border rounded-lg p-6 mb-6">
          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Name Field (Register only) */}
            {!isLogin && (
              <div>
                <label className="block text-sm font-medium text-foreground mb-2">
                  Full Name
                </label>
                <div className="relative">
                  <User className="absolute left-3 top-3 w-5 h-5 text-muted-foreground" />
                  <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Enter your full name"
                    className="w-full bg-background border border-border rounded-lg pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
                  />
                </div>
              </div>
            )}

            {/* Email Field */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-2">
                Email
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 w-5 h-5 text-muted-foreground" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="demo@thinkthonk.com"
                  className="w-full bg-background border border-border rounded-lg pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
                />
              </div>
            </div>

            {/* Password Field */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-2">
                Password
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-3 w-5 h-5 text-muted-foreground" />
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Demo123!@#"
                  className="w-full bg-background border border-border rounded-lg pl-10 pr-10 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-3 text-muted-foreground hover:text-foreground transition-colors"
                >
                  {showPassword ? (
                    <EyeOff className="w-5 h-5" />
                  ) : (
                    <Eye className="w-5 h-5" />
                  )}
                </button>
              </div>
            </div>

            {/* Error Message */}
            {error && (
              <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-3">
                <p className="text-sm text-red-500">{error}</p>
              </div>
            )}

            {/* Success Message */}
            {success && (
              <div className="bg-green-500/10 border border-green-500/20 rounded-lg p-3">
                <p className="text-sm text-green-500">{success}</p>
              </div>
            )}

            {/* Submit Button */}
            <button
              type="submit"
              className="w-full bg-primary hover:bg-primary/90 text-primary-foreground font-medium py-2.5 rounded-lg transition-colors mt-6"
            >
              {isLogin ? 'Sign In' : 'Create Account'}
            </button>
          </form>

          {/* Divider */}
          <div className="relative my-6">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-border"></div>
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-2 bg-card text-muted-foreground">or</span>
            </div>
          </div>

          {/* Toggle Auth Mode */}
          <p className="text-center text-sm text-muted-foreground">
            {isLogin ? "Don't have an account? " : 'Already have an account? '}
            <button
              onClick={() => {
                setIsLogin(!isLogin)
                setError('')
                setSuccess('')
                setEmail('')
                setPassword('')
                setName('')
              }}
              className="text-primary hover:underline font-medium"
            >
              {isLogin ? 'Sign Up' : 'Sign In'}
            </button>
          </p>
        </div>

        {/* Test Credentials Info */}
        <div className="bg-muted/50 border border-border rounded-lg p-4">
          <p className="text-xs font-semibold text-foreground mb-2">Test Credentials:</p>
          <div className="space-y-1 text-xs text-muted-foreground font-mono">
            <p>
              <span className="text-foreground">Email:</span> {testCredentials.email}
            </p>
            <p>
              <span className="text-foreground">Password:</span> {testCredentials.password}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
