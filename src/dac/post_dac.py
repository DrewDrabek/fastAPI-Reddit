from sqlalchemy.orm import Session
from sqlalchemy import text
from app.models.reddit_post import RedditPost, RedditPostCreate, RedditPostUpdate  # Pydantic models

class PostDAC:  # Or UserDAC, CommentDAC, etc.
    def __init__(self, db: Session):
        self.db = db

    def get_all_posts(self) -> list[RedditPost]:
        # ... implementation using self.db.execute ...

    def get_post_by_id(self, post_id: int) -> RedditPost | None:
        # ... implementation ...

    def create_post(self, post: RedditPostCreate) -> RedditPost:
        # ... implementation ...

    def update_post(self, post_id: int, post_update: RedditPostUpdate) -> RedditPost | None:
        # ... implementation ...

    def delete_post(self, post_id: int) -> None:
        # ... implementation .