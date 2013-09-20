-- create tables

CREATE TABLE employees (
  id         SERIAL,
  name       VARCHAR(255) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  start_date DATE NOT NULL,

  PRIMARY KEY (id),

  CONSTRAINT founding_date     CHECK (start_date >= '2009-04-13'),
  CONSTRAINT future_start_date CHECK (start_date <= CURRENT_DATE + 365),
  CONSTRAINT company_email     CHECK (email LIKE '%@example.com')
);

CREATE TABLE projects (
  id   INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL UNIQUE,

  PRIMARY KEY (id)
);

CREATE TABLE employees_projects (
  employee_id INTEGER REFERENCES employees ON DELETE RESTRICT,
  project_id  INTEGER REFERENCES projects  ON DELETE CASCADE,

  PRIMARY KEY (employee_id, project_id)
);

-- seed data

INSERT INTO employees (id, name, email, start_date)
VALUES
  (1,  'Alfred Arnold', 'alfred@example.com', '2009-04-13'),
  (2,  'Benedict Burton', 'benedict@example.com', '2011-09-01'),
  (3,  'Cat Cams', 'cat@example.com', '2009-04-13'),
  (4,  'Duane Drummond', 'duane@example.com', '2009-04-13'),
  (5,  'Elizabeth Eggers', 'elizabeth@example.com', '2009-04-13'),
  (6,  'Fred Fitzgerald', 'fred@example.com', '2012-01-01'),
  (7,  'Greg Gruber', 'greg@example.com', '2013-01-07'),
  (8,  'Horatio Helms', 'horatio@example.com', '2012-01-01'),
  (9,  'Ian Ives', 'ian@example.com', '2009-04-13'),
  (10, 'Jan Jarvis', 'jan@example.com', '2013-01-28'),
  (11, 'Kevin Kelvin', 'kevin@example.com', '2009-04-13'),
  (12, 'Lucy Lemieux', 'lucy@example.com', '2009-04-13');

INSERT INTO projects (id, name)
VALUES
  (1, 'Yoyodyne Inc.'),
  (2, 'Global Omni Mega Corp.'),
  (3, 'Murray''s Widgets Ltd.'),
  (4, 'Spatula City'),
  (5, 'Aperture Laboratories');

INSERT INTO employees_projects (employee_id, project_id)
VALUES
  (1,1),
  (2,1),
  (3,2),
  (4,2),
  (5,3),
  (6,3),
  (7,4),
  (8,4),
  (9,5),
  (10,5),
  (11,5);
