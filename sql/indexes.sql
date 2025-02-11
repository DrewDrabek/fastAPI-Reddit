
-- Foreign Key Indexes
CREATE INDEX idx_posts_userID ON Posts (userID);
CREATE INDEX idx_comments_postID ON Comments (postID);
CREATE INDEX idx_comments_userID ON Comments (userID);