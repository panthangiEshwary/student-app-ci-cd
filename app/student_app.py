from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

# DB connection settings
db_config = {
    'host': os.environ.get("DB_HOST"),
    'user': os.environ.get("DB_USER"),
    'password': os.environ.get("DB_PASSWORD"),
    'database': os.environ.get("DB_NAME"),
    'port': int(os.environ.get("DB_PORT", 3306))
}

DB_NAME = os.environ.get("DB_NAME")

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

# ROUTES
# --------------------------------------------
@app.route("/add_student", methods=["POST"])
def add_student():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data received"}), 400

    try:
        conn = mysql.connector.connect(database=DB_NAME, **db_config)
        cur = conn.cursor()
        cur.execute("INSERT INTO students (name, email, course) VALUES (%s, %s, %s)",
                    (data['name'], data['email'], data['course']))
        conn.commit()
        return jsonify({"message": "Student added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if conn.is_connected():
            cur.close()
            conn.close()

@app.route("/")
def home():
    return "Student App is running", 200
