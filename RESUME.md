# Resuming Moodle Development on Another Computer

This guide provides everything needed to continue working on this project and resume your AI assistant session seamlessly on your home PC or any other machine.

---

## 1. Resume the Antigravity AI Conversation

The unique Conversation ID for this session is:
```text
77043aa4-ba65-4705-896f-f5a4991a1498
```

### Option A: Transfer the Conversation State (Full Chat History)
Antigravity stores conversation brain logs locally. To bring your entire chat history to your home PC:
1. On this machine, copy the folder:
   - **Linux:** `~/.gemini/antigravity-cli/brain/77043aa4-ba65-4705-896f-f5a4991a1498`
2. Paste it into the corresponding folder on your home PC:
   - **Windows:** `C:\Users\<YourUser>\.gemini\antigravity-cli\brain\77043aa4-ba65-4705-896f-f5a4991a1498`
   - **Linux / macOS:** `~/.gemini/antigravity-cli/brain/77043aa4-ba65-4705-896f-f5a4991a1498`
3. In your terminal on your home PC, run:
   ```bash
   agy --conversation=77043aa4-ba65-4705-896f-f5a4991a1498
   ```

### Option B: Fresh Session with Instant Context Handoff (Quickest)
If you do not want to copy folders across machines:
1. On your home PC, open Antigravity CLI / IDE inside the cloned project directory.
2. Send this single message to the AI:
   > *"Read RESUME.md. We are working on Moodle autograding in course CS101. Resume our work on the online tutorial module."*
   The assistant will instantly have complete context and continue seamlessly.

---

## 2. Setting Up the Docker Environment on Your Home PC

### Prerequisites
- Install **Docker Desktop** (or Docker Engine on Linux) with Docker Compose.
- Install **Git**.

### Step-by-Step Setup
```bash
# 1. Clone the environment orchestration repository
git clone https://github.com/codebytushar/moodle-docker-env.git
cd moodle-docker-env

# 2. Clone the customized Moodle codebase into the 'moodle' subfolder
git clone -b MOODLE_503_STABLE https://github.com/codebytushar/moodle-custom.git moodle

# 3. Start the containers
docker compose up -d

# 4. Restore the pre-configured database (Course CS101, Users, Assignments 1 & 2)
docker exec -i moodle_db mariadb -u moodleuser -pmoodlepass moodle < database_seed.sql

# 5. Set your Gemini API key in Moodle
docker exec moodle_web php -r "define('CLI_SCRIPT', true); require('/var/www/html/public/config.php'); set_config('gemini_key', 'YOUR_GEMINI_KEY_HERE', 'local_autograder');"
```

---

## 3. Web Access & Logins

Once containers are running:
- **Moodle:** [http://localhost:8080](http://localhost:8080)
- **phpMyAdmin:** [http://localhost:8081](http://localhost:8081)
- **Mailpit:** [http://localhost:8025](http://localhost:8025)

### Pre-Configured Accounts
| Role | Username | Password | Notes |
| :--- | :--- | :--- | :--- |
| **Site Admin** | `admin` | `Admin@12345` | Full site administration |
| **Teacher** | `teacher1` | `Teacher@12345` | Enrolled as Teacher in CS101 |
| **Student 1** | `student1` | `Student@12345` | Enrolled as Student in CS101 |
| **Student 2** | `student2` | `Student@12345` | Enrolled as Student in CS101 |

---

## 4. Current Work Progress
- **Plugin:** `local_autograder` (located in `moodle/public/local/autograder/`).
- **Course:** `CS101 - Introduction to Python & Automated Grading` (ID: `2`).
- **Assignment 1:** Python Functions (`factorial`, `is_palindrome`) with 5 automated unit tests + Gemini review.
- **Assignment 2:** Java Fibonacci Series ($N=0, 1, 7, 10$) with hidden `<tests>` block + Gemini review.
- **Next Task:** Build the online tutorial submission module for conceptual / syllabus questions.
