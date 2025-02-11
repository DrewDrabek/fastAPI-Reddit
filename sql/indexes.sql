/*

There is a item you might be able to run to help find missing indexes

SELECT * FROM sys.dm_db_missing_index_details;


*/


-- Foreign Key Indexes
CREATE INDEX idx_posts_userID ON Posts (userID);
CREATE INDEX idx_comments_postID ON Comments (postID);
CREATE INDEX idx_comments_userID ON Comments (userID);