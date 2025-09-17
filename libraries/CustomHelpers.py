"""
Custom Robot Framework Library for Todo App Testing
"""
import random
import string
import time
from datetime import datetime
from robot.api import logger


class CustomHelpers:
    """Custom helper functions for Robot Framework tests"""

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def generate_test_user(self, prefix="user"):
        """Generate a unique test username"""
        timestamp = int(time.time())
        random_str = ''.join(random.choices(string.ascii_lowercase, k=5))
        return f"{prefix}_{timestamp}_{random_str}"

    def generate_test_email(self, username=None):
        """Generate a test email address"""
        if not username:
            username = self.generate_test_user()
        return f"{username}@test.com"

    def generate_todo_text(self, length=20):
        """Generate random todo text"""
        words = ['buy', 'get', 'finish', 'complete', 'review', 'send',
                 'call', 'meet', 'prepare', 'organize', 'clean', 'fix']
        items = ['milk', 'report', 'homework', 'presentation', 'email',
                 'documents', 'room', 'car', 'dinner', 'meeting']

        verb = random.choice(words)
        item = random.choice(items)
        return f"{verb.capitalize()} {item}"

    def wait_for_websocket_sync(self, timeout=5):
        """Wait for WebSocket synchronization"""
        time.sleep(timeout)
        logger.info(f"Waited {timeout} seconds for WebSocket sync")

    def get_timestamp(self):
        """Get current timestamp"""
        return datetime.now().strftime("%Y%m%d_%H%M%S")

    def validate_todo_format(self, todo_text):
        """Validate todo text format"""
        if not todo_text or len(todo_text.strip()) == 0:
            return False, "Todo text cannot be empty"
        if len(todo_text) > 500:
            return False, "Todo text too long"
        return True, "Valid todo format"

    def calculate_test_duration(self, start_time, end_time):
        """Calculate test execution duration"""
        duration = float(end_time) - float(start_time)
        return round(duration, 2)