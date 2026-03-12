-- Setup Ideas Table for Admin Content Creation
-- This script creates the ideas table for storing user-generated content
-- Run this script in your database before deploying the admin feature

CREATE TABLE IF NOT EXISTS ideas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Content Fields
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  explanation TEXT NOT NULL,
  example TEXT NOT NULL,
  takeaway TEXT NOT NULL,
  custom_heading TEXT,
  custom_content TEXT,
  
  -- Engagement Metrics
  likes_count INT DEFAULT 0,
  saves_count INT DEFAULT 0,
  share_count INT DEFAULT 0,
  comments_count INT DEFAULT 0,
  
  -- Status & Metadata
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  created_by UUID,
  
  -- Timestamps
  created_on TIMESTAMP DEFAULT NOW(),
  published_on TIMESTAMP,
  modified_on TIMESTAMP DEFAULT NOW(),
  
  -- Indexes for better query performance
  CONSTRAINT ideas_valid_status CHECK (status IN ('draft', 'published'))
);

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_ideas_status ON ideas(status);
CREATE INDEX IF NOT EXISTS idx_ideas_category ON ideas(category);
CREATE INDEX IF NOT EXISTS idx_ideas_created_by ON ideas(created_by);
CREATE INDEX IF NOT EXISTS idx_ideas_created_on ON ideas(created_on DESC);
CREATE INDEX IF NOT EXISTS idx_ideas_published_on ON ideas(published_on DESC);

-- Create view for published ideas (useful for frontend queries)
CREATE OR REPLACE VIEW published_ideas AS
SELECT * FROM ideas WHERE status = 'published' ORDER BY published_on DESC;

-- Add helpful comment
COMMENT ON TABLE ideas IS 'Stores user-created content ideas with engagement metrics and publishing status';
COMMENT ON COLUMN ideas.status IS 'Draft or Published - determines visibility';
COMMENT ON COLUMN ideas.created_by IS 'UUID of the user who created the idea';
