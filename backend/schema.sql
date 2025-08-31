CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  password_hash TEXT,
  role VARCHAR(50) DEFAULT 'user',
  reputation INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scripts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200),
  slug VARCHAR(200) UNIQUE,
  description TEXT,
  author_id INT REFERENCES users(id),
  tags TEXT,
  visibility VARCHAR(50) DEFAULT 'public',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE script_versions (
  id SERIAL PRIMARY KEY,
  script_id INT REFERENCES scripts(id),
  version VARCHAR(50),
  file_path TEXT,
  file_size BIGINT,
  checksum TEXT,
  changelog TEXT,
  uploaded_by INT REFERENCES users(id),
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE downloads (
  id SERIAL PRIMARY KEY,
  script_version_id INT REFERENCES script_versions(id),
  user_id INT REFERENCES users(id),
  ip VARCHAR(50),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  script_id INT REFERENCES scripts(id),
  user_id INT REFERENCES users(id),
  content TEXT,
  rating INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE favorites (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  script_id INT REFERENCES scripts(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reports (
  id SERIAL PRIMARY KEY,
  script_id INT REFERENCES scripts(id),
  user_id INT REFERENCES users(id),
  reason TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  action VARCHAR(100),
  target_type VARCHAR(100),
  target_id INT,
  meta_json JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
