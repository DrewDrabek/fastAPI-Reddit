
-- Foreign Key Indexes
CREATE INDEX idx_posts_userID ON Posts (userID);
CREATE INDEX idx_comments_postID ON Comments (postID);
CREATE INDEX idx_comments_userID ON Comments (userID);


-- These are really just guesses for training on the indexes that are needed to make but really you should profile that database or have a tool that monitors the database 

-- The format is the core command and then the name and then the table and the columns to make the index on