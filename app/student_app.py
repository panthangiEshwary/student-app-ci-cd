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

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/add_student", methods=["POST"])
def add_student():
    name = request.form["name"]
    age = request.form["age"]
    email = request.form["email"]

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO students (name, age, email) VALUES (%s, %s, %s)", (name, age, email))
        conn.commit()
        return "Student added successfully"
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        conn.close()

@app.route("/students")
def get_students():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM students")
        students = cursor.fetchall()
        return render_template("students.html", students=students)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        conn.close()

def initialize_database():
    try:
        connection = mysql.connector.connect(
            host=db_config['host'],
            user=db_config['user'],
            password=db_config['password'],
            port=db_config['port']
        )
        cursor = connection.cursor()
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")
        connection.database = DB_NAME
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS students (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255),
                age INT,
                email VARCHAR(255)
            )
        """)
        connection.commit()
    except Exception as e:
        print("Database initialization failed:", e)
    finally:
        cursor.close()
        connection.close()

if __name__ == "__main__":
    initialize_database()
    app.run(host="0.0.0.0", port=5000)
