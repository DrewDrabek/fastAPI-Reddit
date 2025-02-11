
-- Sample Data Creation

-- Create two sample users
DO $$
DECLARE
    user1_id UUID;
    user2_id UUID;
BEGIN
    -- User 1
    PERFORM CreateUser(_userID := uuid_generate_v4(), _joinDate := (NOW() - INTERVAL '3 days')::TIMESTAMP); -- Call CreateUser with TIMESTAMP cast
    SELECT userID FROM Users ORDER BY joinDate DESC LIMIT 1 INTO user1_id; -- Get the userID of the last inserted user

    -- User 2
    PERFORM CreateUser(_userID := uuid_generate_v4(), _joinDate := (NOW() - INTERVAL '1 day')::TIMESTAMP); -- Call CreateUser with TIMESTAMP cast
    SELECT userID FROM Users ORDER BY joinDate DESC LIMIT 1 INTO user2_id; -- Get the userID of the last inserted user


    RAISE NOTICE 'Sample Users created with IDs: % and %', user1_id, user2_id;

    -- Create two sample posts
    DECLARE
        post1_id UUID;
        post2_id UUID;
    BEGIN
        -- Post 1 by User 1
        SELECT CreatePost(_userID := user1_id, _postContent := 'Hello world! This is my first post.') INTO post1_id;

        -- Post 2 by User 2
        SELECT CreatePost(_userID := user2_id, _postContent := 'Just sharing some thoughts today.') INTO post2_id;

        RAISE NOTICE 'Sample Posts created with IDs: % and %', post1_id, post2_id;

        -- Add one comment to each post by the *other* user
        -- Comment on Post 1 by User 2
        PERFORM AddComment(_userID := user2_id, _postID := post1_id, _commentContent := 'Great post! I agree.');

        -- Comment on Post 2 by User 1
        PERFORM AddComment(_userID := user1_id, _postID := post2_id, _commentContent := 'Interesting perspective, thanks for sharing.');

        RAISE NOTICE 'Sample Comments added to Posts.';

    END;
END $$;

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Comments;