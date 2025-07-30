from flask import Flask, request, jsonify
import psycopg2
import os

app = Flask(__name__)

# Database config from environment variables
db_config = {
    'host': os.environ.get("DB_HOST"),
    'user': os.environ.get("DB_USER"),
    'password': os.environ.get("DB_PASSWORD"),
    'dbname': os.environ.get("DB_NAME"),
    'port': os.environ.get("DB_PORT", 5432)
}

# Connect to PostgreSQL
def get_connection():
    return psycopg2.connect(**db_config)

@app.route('/add_student', methods=['POST'])
def add_student():
    data = request.get_json()
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO students (name, email, course) VALUES (%s, %s, %s)",
                    (data['name'], data['email'], data['course']))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Student added successfully!"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/students', methods=['GET'])
def get_students():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, name, email, course FROM students")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        students = [{"id": r[0], "name": r[1], "email": r[2], "course": r[3]} for r in rows]
        return jsonify(students)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
