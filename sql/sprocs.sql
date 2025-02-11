-- Enable the uuid-ossp extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateUser: Registers a New User
CREATE OR REPLACE FUNCTION CreateUser(
    _userID UUID,
    _joinDate TIMESTAMP DEFAULT NOW()
) RETURNS VOID AS $$
    INSERT INTO Users (userID, joinDate)
    VALUES (_userID, _joinDate);
$$ LANGUAGE sql;

-- CreatePost: User Creates a Post
CREATE OR REPLACE FUNCTION CreatePost(
    _userID UUID,
    _postContent VARCHAR(200),
    _pictureUrl VARCHAR(50) DEFAULT NULL
) RETURNS UUID AS $$
    INSERT INTO Posts (userID, postContent, dateAdded, pictureUrl)
    VALUES (_userID, _postContent, NOW(), _pictureUrl)
    RETURNING postID; -- Directly return the generated postID
$$ LANGUAGE sql;

-- GetPosts: Fetch All Posts
CREATE OR REPLACE FUNCTION GetPosts()
RETURNS TABLE (
    postID UUID,
    userID UUID,
    joinDate TIMESTAMP,
    postContent VARCHAR(200),
    pictureUrl VARCHAR(50),
    dateAdded TIMESTAMP
) AS $$
    SELECT
        p.postID, p.userID, u.joinDate,
        p.postContent, p.pictureUrl, p.dateAdded
    FROM Posts p
    JOIN Users u ON p.userID = u.userID
    ORDER BY p.dateAdded DESC;
$$ LANGUAGE sql;

-- GetPostsByUser: Fetch Posts by a Specific User
CREATE OR REPLACE FUNCTION GetPostsByUser(_userID UUID)
RETURNS TABLE (
    postID UUID,
    postContent VARCHAR(200),
    pictureUrl VARCHAR(50),
    dateAdded TIMESTAMP
) AS $$
    SELECT postID, postContent, pictureUrl, dateAdded
    FROM Posts
    WHERE userID = _userID
    ORDER BY dateAdded DESC;
$$ LANGUAGE sql;

-- AddComment: User Adds a Comment
CREATE OR REPLACE FUNCTION AddComment(
    _userID UUID,
    _postID UUID,
    _commentContent VARCHAR(500)
) RETURNS UUID AS $$
DECLARE
    _commentID UUID; -- Declare _commentID variable
BEGIN
    _commentID := uuid_generate_v4(); -- Assign UUID to the variable
    INSERT INTO Comments (commentID, userID, postID, commentContent, dateAdded)
    VALUES (_commentID, _userID, _postID, _commentContent, NOW());

    RETURN _commentID;
END;
$$ LANGUAGE plpgsql; -- Changed to plpgsql

-- GetCommentsByPost: Fetch Comments for a Post
CREATE OR REPLACE FUNCTION GetCommentsByPost(_postID UUID)
RETURNS TABLE (
    commentID UUID,
    userID UUID,
    commentContent VARCHAR(500),
    dateAdded TIMESTAMP
) AS $$
    SELECT c.commentID, c.userID, c.commentContent, c.dateAdded
    FROM Comments c
    WHERE c.postID = _postID
    ORDER BY c.dateAdded ASC;
$$ LANGUAGE sql;

-- DeletePost: Remove a Post and Its Comments
CREATE OR REPLACE FUNCTION DeletePost(_postID UUID)
RETURNS VOID AS $$
    DELETE FROM Posts WHERE postID = _postID;
$$ LANGUAGE sql;

-- DeleteComment: Remove a Specific Comment
CREATE OR REPLACE FUNCTION DeleteComment(_commentID UUID)
RETURNS VOID AS $$
    DELETE FROM Comments WHERE commentID = _commentID;
$$ LANGUAGE sql;