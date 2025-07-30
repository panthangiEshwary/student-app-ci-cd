from flask import Flask, render_template, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

db_config = {
    'host': os.environ.get("DB_HOST"),
    'user': os.environ.get("DB_USER"),
    'password': os.environ.get("DB_PASSWORD"),
    'database': os.environ.get("DB_NAME"),
    'port': int(os.environ.get("DB_PORT", 3306))
}

DB_NAME = db_config['database']

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/students.html")
def student_page():
    return render_template("students.html")
	
# FUNCTION: Initialize DB and students table
# --------------------------------------------
def initialize_database():
    try:
        # Connect without specifying DB to create it
        conn = mysql.connector.connect(**db_config)
        cur = conn.cursor()

        # Create the database if it doesn't exist
        cur.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")
        conn.commit()

        # Connect to the new DB
        conn.database = DB_NAME

        # Create the students table if not exists
        cur.execute("""
            CREATE TABLE IF NOT EXISTS students (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100),
                email VARCHAR(100),
                course VARCHAR(100)
            )
        """)
        conn.commit()

    except Exception as e:
        print("DB init error:", e)
    finally:
        if conn.is_connected():
            cur.close()
            conn.close()

# Call DB initialization at app start
initialize_database()

@app.route("/add_student", methods=["POST"])
def add_student():
    data = request.get_json()
    conn = None
    cur = None
    try:
        conn = mysql.connector.connect(**db_config)
        cur = conn.cursor()
        cur.execute("INSERT INTO students (name, email, course) VALUES (%s, %s, %s)",
                    (data['name'], data['email'], data['course']))
        conn.commit()
        return jsonify({"message": "Student added"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

@app.route("/students", methods=["GET"])
def get_students():
    try:
        conn = mysql.connector.connect(**db_config)
        cur = conn.cursor()
        cur.execute("SELECT * FROM students")
        rows = cur.fetchall()
        return jsonify([{"id": r[0], "name": r[1], "email": r[2], "course": r[3]} for r in rows])
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        conn.close()

@app.route("/health", methods=["GET"])
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(debug=True)  # Set debug=True for development