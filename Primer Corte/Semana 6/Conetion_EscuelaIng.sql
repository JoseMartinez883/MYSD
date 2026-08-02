-- (Tablas)
CREATE TABLE guest (
    id NUMBER(10),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    address VARCHAR2(100)
);

CREATE TABLE room (
    id NUMBER(10),
    room_type VARCHAR2(20),
    max_occupancy NUMBER(2)
);

CREATE TABLE booking (
    booking_id NUMBER(10),
    booking_date DATE,
    occupants NUMBER(2),
    guest_id NUMBER(10),
    room_id NUMBER(10),
    nights NUMBER(2),
    arrival_time VARCHAR2(5)
);

-- (Atributos, Primarias, Únicas, Foraneas)
ALTER TABLE guest ADD CONSTRAINT PK_GUEST PRIMARY KEY (id);

ALTER TABLE room ADD CONSTRAINT PK_ROOM PRIMARY KEY (id);
ALTER TABLE room ADD CONSTRAINT CK_ROOM_OCCUPANCY CHECK (max_occupancy > 0);

ALTER TABLE booking ADD CONSTRAINT PK_BOOKING PRIMARY KEY (booking_id);
ALTER TABLE booking ADD CONSTRAINT FK_BOOKING_GUEST FOREIGN KEY (guest_id) REFERENCES guest(id);
ALTER TABLE booking ADD CONSTRAINT FK_BOOKING_ROOM FOREIGN KEY (room_id) REFERENCES room(id);
ALTER TABLE booking ADD CONSTRAINT CK_BOOKING_NIGHTS CHECK (nights > 0);

-- (PoblarOK)
INSERT INTO guest (id, first_name, last_name, address) VALUES (1001, 'Ruth', 'Bowman', '25109 High Street');
INSERT INTO guest (id, first_name, last_name, address) VALUES (1002, 'Jenny', 'Smyth', '757788 High Street');

INSERT INTO room (id, room_type, max_occupancy) VALUES (101, 'Single', 1);
INSERT INTO room (id, room_type, max_occupancy) VALUES (201, 'Double', 2);

INSERT INTO booking (booking_id, booking_date, occupants, guest_id, room_id, nights, arrival_time) 
VALUES (5001, TO_DATE('2026-02-12', 'YYYY-MM-DD'), 1, 1001, 101, 3, '14:00');
COMMIT;

-- (PoblarNoOK)
-- 1. Error de PK: ID de huésped duplicado
-- INSERT INTO guest (id, first_name) VALUES (1001, 'Duplicado');

-- 2. Error de FK: Reserva para una habitación que no existe
-- INSERT INTO booking (booking_id, guest_id, room_id) VALUES (5002, 1001, 999);

-- 3. Error de Check: Ocupantes negativos o cero
-- INSERT INTO room (id, max_occupancy) VALUES (301, 0);

-- (Consultas)
-- 1. Listar huéspedes y sus habitaciones (Join)
SELECT g.first_name, g.last_name, b.booking_date, r.room_type 
FROM guest g 
JOIN booking b ON g.id = b.guest_id 
JOIN room r ON b.room_id = r.id;

-- 2. Consulta de Ocupación Detallada (Similar a las de SQLZoo Medium)
-- Muestra qué huéspedes tienen reservas, en qué tipo de habitación están y cuántos días se quedan.
SELECT 
    g.first_name || ' ' || g.last_name AS huesped, 
    r.room_type AS tipo_habitacion, 
    b.nights AS noches_estadia,
    b.booking_date AS fecha_llegada
FROM guest g
JOIN booking b ON g.id = b.guest_id
JOIN room r ON b.room_id = r.id
ORDER BY b.booking_date DESC;

-- (XPoblar)
-- Vaciar la base de datos respetando el orden de las llaves foráneas
DELETE FROM booking;
DELETE FROM guest;
DELETE FROM room;
COMMIT;

-- (XTablas)
-- Eliminar las tablas permanentemente
DROP TABLE booking;
DROP TABLE guest;
DROP TABLE room;