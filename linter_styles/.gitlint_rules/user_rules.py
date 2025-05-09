"""User-defined rules for commit message linting."""
from gitlint.rules import LineMustNotContainWord, CommitMessageBody


class BodyMustNotContainWord(LineMustNotContainWord):
    """Ensure the body does not contain the dis-allowed words."""
    name = "body-must-not-contain-word"
    id = "UC1"
    target = CommitMessageBody
