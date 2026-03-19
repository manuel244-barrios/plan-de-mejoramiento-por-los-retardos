-- Base de datos para una biblioteca
CREATE DATABASE IF NOT EXISTS biblioteca;

USE biblioteca;

-- Tabla de autores
CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    nacionalidad VARCHAR(50)
);

-- Tabla de libros
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT,
    isbn VARCHAR(20) UNIQUE,
    anio_publicacion YEAR,
    genero VARCHAR(50),
    descripcion TEXT,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (autor_id) REFERENCES autores(id) ON DELETE SET NULL
);

-- Tabla de lectores (usuarios de la biblioteca)
CREATE TABLE lectores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla de préstamos
CREATE TABLE prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    lector_id INT NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_esperada DATE,
    fecha_devolucion_real DATE,
    estado ENUM('activo', 'devuelto', 'atrasado') DEFAULT 'activo',
    FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE,
    FOREIGN KEY (lector_id) REFERENCES lectores(id) ON DELETE CASCADE
);

-- Tabla de categorías/géneros
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla intermedia para libros y categorías (muchos a muchos)
CREATE TABLE libro_categoria (
    libro_id INT,
    categoria_id INT,
    PRIMARY KEY (libro_id, categoria_id),
    FOREIGN KEY (libro_id) REFERENCES libros(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_libros_titulo ON libros(titulo);
CREATE INDEX idx_libros_autor ON libros(autor_id);
CREATE INDEX idx_prestamos_libro ON prestamos(libro_id);
CREATE INDEX idx_prestamos_lector ON prestamos(lector_id);
CREATE INDEX idx_prestamos_fecha ON prestamos(fecha_prestamo);

-- Datos de ejemplo
INSERT INTO autores (nombre, apellido, fecha_nacimiento, nacionalidad) VALUES
('Gabriel', 'García Márquez', '1927-03-06', 'Colombiano'),
('Isabel', 'Allende', '1942-08-02', 'Chilena'),
('Mario', 'Vargas Llosa', '1936-03-28', 'Peruano'),
('Julio', 'Cortázar', '1914-08-26', 'Argentino');

INSERT INTO categorias (nombre, descripcion) VALUES
('Novela', 'Obras de ficción narrativa'),
('Realismo mágico', 'Estilo literario que combina elementos realistas con fantásticos'),
('Ensayo', 'Obras de reflexión y análisis'),
('Poesía', 'Obras en verso');

INSERT INTO libros (titulo, autor_id, isbn, anio_publicacion, genero, descripcion) VALUES
('Cien años de soledad', 1, '978-84-376-0494-7', 1967, 'Novela', 'La historia de la familia Buendía en Macondo'),
('La casa de los espíritus', 2, '978-84-204-0121-3', 1982, 'Novela', 'Saga familiar con elementos mágicos'),
('La ciudad y los perros', 3, '978-84-206-1932-1', 1963, 'Novela', 'Novela sobre la vida en un colegio militar'),
('Rayuela', 4, '978-84-339-3505-9', 1963, 'Novela', 'Novela experimental con múltiples lecturas');

INSERT INTO lectores (nombre, apellido, email, telefono) VALUES
('Ana', 'García', 'ana.garcia@email.com', '555-1234'),
('Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', '555-5678'),
('María', 'López', 'maria.lopez@email.com', '555-9012');

-- Asignar categorías a libros
INSERT INTO libro_categoria (libro_id, categoria_id) VALUES
(1, 1), (1, 2), -- Cien años de soledad: Novela, Realismo mágico
(2, 1), (2, 2), -- La casa de los espíritus: Novela, Realismo mágico
(3, 1), -- La ciudad y los perros: Novela
(4, 1); -- Rayuela: Novela




