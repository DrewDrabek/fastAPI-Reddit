
-- CreateUser: Registers a New User
CREATE OR REPLACE FUNCTION CreateUser( -- The create or replace is nice to use just incase
    _userID UUID, -- The _ is a common way to distinguish 
    _joinDate TIMESTAMP DEFAULT NOW()
) RETURNS VOID AS $$ -- This means that the sproc does not return anything - the $$ define the function body and are like more over ''
    INSERT INTO Users (userID, joinDate)
    VALUES (_userID, _joinDate);
$$ LANGUAGE sql; -- THis is the end of the sproc and the langauage that is going to be used

-- CreatePost: User Creates a Post
CREATE OR REPLACE FUNCTION CreatePost(
    _userID UUID,
    _postContent VARCHAR(200), -- 200 is the length of the text that is allowed
    _pictureUrl VARCHAR(50) DEFAULT NULL -- the default null is because not everything is going to have a pocture
) RETURNS UUID AS $$
    INSERT INTO Posts (userID, postContent, dateAdded, pictureUrl)
    VALUES (_userID, _postContent, NOW(), _pictureUrl) -- the now is for when the post is added
    RETURNING postID; -- Directly return the generated postID
$$ LANGUAGE sql;

-- GetPosts: Fetch All Posts
CREATE OR REPLACE FUNCTION GetPosts()
RETURNS TABLE (
    postID UUID, -- These are the contents that are returned
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
    JOIN Users u ON p.userID = u.userID -- this is an inner join
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
    _commentID := uuid_generate_v4(); -- Assign UUID to the variable before the insert statement 
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

-- Here is a comment that goes over the joins

-- SQL JOIN Types: Short Explanation

-- INNER JOIN: Returns only rows where there's a match in BOTH tables based on the join condition.
--   If there's no match in either table, the row is excluded.  Most common join type.
--   Example:  SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id;

-- LEFT (OUTER) JOIN: Returns ALL rows from the LEFT table, and the matching rows from the RIGHT table.
--   If there's no match in the RIGHT table, NULL values are returned for the RIGHT table's columns.
--   Example:  SELECT * FROM table1 LEFT JOIN table2 ON table1.id = table2.id;

-- RIGHT (OUTER) JOIN: Returns ALL rows from the RIGHT table, and the matching rows from the LEFT table.
--   If there's no match in the LEFT table, NULL values are returned for the LEFT table's columns.
--   (Essentially the reverse of LEFT JOIN; less commonly used than LEFT JOIN).
--   Example:  SELECT * FROM table1 RIGHT JOIN table2 ON table1.id = table2.id;

-- FULL (OUTER) JOIN: Returns ALL rows from BOTH tables.
--   If there's a match, the corresponding rows are combined.
--   If there's no match in one table, NULL values are returned for that table's columns.
--   Example:  SELECT * FROM table1 FULL OUTER JOIN table2 ON table1.id = table2.id;

-- SQL JOIN Types: Visual Explanation (Venn Diagram Analogy)

-- INNER JOIN:  Think of it as the "overlap" or "intersection" of two circles (Venn diagram).  Only the parts where they both have data.
--   Example:  SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id;

-- LEFT (OUTER) JOIN:  The *entire* left circle, plus the *overlapping* part with the right circle.  Any parts of the left circle that *don't* overlap get paired with NULLs from the right.
--   Example:  SELECT * FROM table1 LEFT JOIN table2 ON table1.id = table2.id;

-- RIGHT (OUTER) JOIN: The *entire* right circle, plus the *overlapping* part. (NULLs for non-matching left-side data)
--   Example:  SELECT * FROM table1 RIGHT JOIN table2 ON table1.id = table2.id;

-- FULL (OUTER) JOIN:  *Both* entire circles.  If there's overlap, great.  If not, NULLs fill in the gaps.
--   Example:  SELECT * FROM table1 FULL OUTER JOIN table2 ON table1.id = table2.id;
