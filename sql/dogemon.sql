CREATE TABLE node (
  node_id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  ip_address VARCHAR(45),
  UNIQUE (name));

CREATE TABLE plugin (
  plugin_id INTEGER PRIMARY KEY,
  module VARCHAR(255) NOT NULL,
  UNIQUE (module));

CREATE TABLE plugin_option (
  plugin_option_id INTEGER PRIMARY KEY,
  plugin_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  is_required INTEGER NOT NULL,
  is_freeform INTEGER NOT NULL,
  allow_multiple INTEGER NOT NULL,
  UNIQUE (plugin_id, name),
  FOREIGN KEY (plugin_id) REFERENCES plugin (plugin_id) ON DELETE CASCADE);

CREATE TABLE plugin_option_choice (
  plugin_option_choice_id INTEGER PRIMARY KEY,
  plugin_option_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  UNIQUE (plugin_option_id, name),
  FOREIGN KEY (plugin_option_id) REFERENCES plugin_option (plugin_option_id) ON DELETE CASCADE);

CREATE TABLE service (
  service_id INTEGER PRIMARY KEY,
  node_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  plugin_id INTEGER NOT NULL,
  interval INTEGER NOT NULL,
  timeout INTEGER NOT NULL,
  UNIQUE (node_id, name),
  FOREIGN KEY (node_id) REFERENCES node (node_id) ON DELETE CASCADE,
  FOREIGN KEY (plugin_id) REFERENCES plugin (plugin_id) ON DELETE CASCADE);

CREATE TABLE service_option (
  service_option_id INTEGER PRIMARY KEY,
  service_id INTEGER NOT NULL,
  plugin_option_id INTEGER NOT NULL,
  plugin_option_choice_id INTEGER,
  freeform_value VARCHAR(255),
  FOREIGN KEY (service_id) REFERENCES service (service_id) ON DELETE CASCADE,
  FOREIGN KEY (plugin_option_id) REFERENCES plugin_option (plugin_option_id) ON DELETE CASCADE,
  FOREIGN KEY (plugin_option_choice_id) REFERENCES plugin_option_choice (plugin_option_choice_id) ON DELETE CASCADE);
