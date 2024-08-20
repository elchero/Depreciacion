-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-08-2024 a las 05:48:26
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `conta1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_depreciacion_anual` (IN `id_activo` INT)   BEGIN
    DECLARE fecha_adquisicion DATE;
    DECLARE vida_util INT;
    DECLARE tasa_depreciacion DECIMAL(5,2);
    DECLARE costo DECIMAL(10,2);
    DECLARE valor_residual DECIMAL(10,2);
    DECLARE anio_actual DATE;
    DECLARE anio_final DATE;
    DECLARE depreciacion_anual DECIMAL(10,2);
    DECLARE depreciacion_acumulada DECIMAL(10,2) DEFAULT 0;
    DECLARE valor_en_libro DECIMAL(10,2);

    -- Obtener los datos del activo
    SELECT 
        a.fecha_adquisicion,
        ac.vida_util,
        ac.tasa_depreciacion,
        a.costo,
        a.valor_residual
    INTO 
        fecha_adquisicion,
        vida_util,
        tasa_depreciacion,
        costo,
        valor_residual
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria
    WHERE a.idactivo = id_activo;

    -- Calcular la depreciación anual
    SET depreciacion_anual = ROUND((costo - valor_residual) * (tasa_depreciacion / 100), 2);

    -- Crear una tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS DepreciacionAnual (
        anio VARCHAR(255),  -- Cambiado a VARCHAR para almacenar la fecha formateada
        nombreactivofami VARCHAR(255),
        marca VARCHAR(255),
        depreciacion_anual DECIMAL(10,2),
        depreciacion_acumulada DECIMAL(10,2),
        valor_en_libro DECIMAL(10,2)
    );

    -- Limpiar la tabla temporal
    TRUNCATE TABLE DepreciacionAnual;

    -- Insertar datos en la tabla temporal para el Año 0
    SET valor_en_libro = costo;
    INSERT INTO DepreciacionAnual (anio, nombreactivofami, marca, depreciacion_anual, depreciacion_acumulada, valor_en_libro)
    SELECT 
        DATE_FORMAT(fecha_adquisicion, '%d de %M del %Y') AS anio,
        af.nombreactivofami,
        a.marca,
        0 AS depreciacion_anual,
        0 AS depreciacion_acumulada,
        costo AS valor_en_libro
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    WHERE a.idactivo = id_activo;

    -- Insertar datos en la tabla temporal para los años siguientes
    SET anio_actual = DATE_ADD(fecha_adquisicion, INTERVAL 1 YEAR);
    SET anio_final = DATE_ADD(fecha_adquisicion, INTERVAL vida_util YEAR);

    WHILE anio_actual <= anio_final DO
        SET depreciacion_acumulada = depreciacion_acumulada + depreciacion_anual;
        SET valor_en_libro = costo - depreciacion_acumulada;

        -- Asegurarse de que el valor en libros no sea menor que el valor residual
        IF valor_en_libro < valor_residual THEN
            SET depreciacion_anual = valor_en_libro - valor_residual;
            SET valor_en_libro = valor_residual;
        END IF;

        INSERT INTO DepreciacionAnual (anio, nombreactivofami, marca, depreciacion_anual, depreciacion_acumulada, valor_en_libro)
        SELECT 
            DATE_FORMAT(anio_actual, '%d de %M del %Y') AS anio,
            af.nombreactivofami,
            a.marca,
            depreciacion_anual,
            depreciacion_acumulada,
            valor_en_libro
        FROM activo a
        JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
        WHERE a.idactivo = id_activo;

        SET anio_actual = DATE_ADD(anio_actual, INTERVAL 1 YEAR);
    END WHILE;

    -- Seleccionar los resultados
    SELECT * FROM DepreciacionAnual;

    -- Limpiar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS DepreciacionAnual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_depreciacion_diaria` (IN `id_activo` INT)   BEGIN
    DECLARE fecha_adquisicion DATE;
    DECLARE vida_util INT;
    DECLARE tasa_depreciacion DECIMAL(5,2);
    DECLARE costo DECIMAL(10,2);
    DECLARE valor_residual DECIMAL(10,2);
    DECLARE dia_actual DATE;
    DECLARE dia_final DATE;
    DECLARE depreciacion_anual DECIMAL(10,2);
    DECLARE depreciacion_diaria DECIMAL(10,8);
    DECLARE depreciacion_acumulada DECIMAL(10,2) DEFAULT 0;
    DECLARE valor_en_libro DECIMAL(10,2);

    -- Obtener los datos del activo
    SELECT 
        a.fecha_adquisicion,
        ac.vida_util,
        a.costo,
        a.valor_residual
    INTO 
        fecha_adquisicion,
        vida_util,
        costo,
        valor_residual
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria
    WHERE a.idactivo = id_activo;

    -- Calcular la depreciación anual
    SET depreciacion_anual = (costo - valor_residual) / vida_util;

    -- Calcular la depreciación diaria sin redondeo inmediato
    IF (YEAR(fecha_adquisicion) % 4 = 0 AND YEAR(fecha_adquisicion) % 100 != 0) OR (YEAR(fecha_adquisicion) % 400 = 0) THEN
        SET depreciacion_diaria = depreciacion_anual / 366;
    ELSE
        SET depreciacion_diaria = depreciacion_anual / 365;
    END IF;

    -- Crear una tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS DepreciacionDiaria (
        dia VARCHAR(255),
        nombreactivofami VARCHAR(255),
        marca VARCHAR(255),
        depreciacion_diaria DECIMAL(10,2),
        depreciacion_acumulada DECIMAL(10,2),
        valor_en_libro DECIMAL(10,2)
    );

    -- Limpiar la tabla temporal
    TRUNCATE TABLE DepreciacionDiaria;

    -- Insertar datos en la tabla temporal para el Día 0
    SET valor_en_libro = costo;
    INSERT INTO DepreciacionDiaria (dia, nombreactivofami, marca, depreciacion_diaria, depreciacion_acumulada, valor_en_libro)
    SELECT 
        DATE_FORMAT(fecha_adquisicion, '%d de %M del %Y') AS dia,
        af.nombreactivofami,
        a.marca,
        0 AS depreciacion_diaria,
        0 AS depreciacion_acumulada,
        costo AS valor_en_libro
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    WHERE a.idactivo = id_activo;

    -- Insertar datos en la tabla temporal para los días siguientes
    SET dia_actual = DATE_ADD(fecha_adquisicion, INTERVAL 1 DAY);
    SET dia_final = DATE_ADD(fecha_adquisicion, INTERVAL vida_util YEAR);

    WHILE dia_actual <= dia_final DO
        SET depreciacion_acumulada = depreciacion_acumulada + ROUND(depreciacion_diaria, 2);
        SET valor_en_libro = costo - depreciacion_acumulada;

        -- Ajuste en el último día si es necesario
        IF dia_actual = dia_final AND valor_en_libro > valor_residual THEN
            SET depreciacion_diaria = valor_en_libro - valor_residual;
            SET valor_en_libro = valor_residual;
        END IF;

        INSERT INTO DepreciacionDiaria (dia, nombreactivofami, marca, depreciacion_diaria, depreciacion_acumulada, valor_en_libro)
        SELECT 
            DATE_FORMAT(dia_actual, '%d de %M del %Y') AS dia,
            af.nombreactivofami,
            a.marca,
            ROUND(depreciacion_diaria, 2),
            depreciacion_acumulada,
            valor_en_libro
        FROM activo a
        JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
        WHERE a.idactivo = id_activo;

        SET dia_actual = DATE_ADD(dia_actual, INTERVAL 1 DAY);
    END WHILE;

    -- Seleccionar los resultados
    SELECT * FROM DepreciacionDiaria;

    -- Limpiar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS DepreciacionDiaria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_depreciacion_mensual` (IN `id_activo` INT)   BEGIN
    DECLARE fecha_adquisicion DATE;
    DECLARE vida_util INT;
    DECLARE tasa_depreciacion DECIMAL(5,2);
    DECLARE costo DECIMAL(10,2);
    DECLARE valor_residual DECIMAL(10,2);
    DECLARE mes_actual DATE;
    DECLARE mes_final DATE;
    DECLARE depreciacion_mensual DECIMAL(10,2);
    DECLARE depreciacion_acumulada DECIMAL(10,2) DEFAULT 0;
    DECLARE valor_en_libro DECIMAL(10,2);

    -- Obtener los datos del activo
    SELECT 
        a.fecha_adquisicion,
        ac.vida_util,
        ac.tasa_depreciacion,
        a.costo,
        a.valor_residual
    INTO 
        fecha_adquisicion,
        vida_util,
        tasa_depreciacion,
        costo,
        valor_residual
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria
    WHERE a.idactivo = id_activo;

    -- Calcular la depreciación mensual
    SET depreciacion_mensual = ROUND((costo - valor_residual) * (tasa_depreciacion / 100) / 12, 2);

    -- Crear una tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS DepreciacionMensual (
        mes VARCHAR(255),  -- Cambiado a VARCHAR para almacenar la fecha formateada
        nombreactivofami VARCHAR(255),
        marca VARCHAR(255),
        depreciacion_mensual DECIMAL(10,2),
        depreciacion_acumulada DECIMAL(10,2),
        valor_en_libro DECIMAL(10,2)
    );

    -- Limpiar la tabla temporal
    TRUNCATE TABLE DepreciacionMensual;

    -- Insertar datos en la tabla temporal para el Mes 0
    SET valor_en_libro = costo;
    INSERT INTO DepreciacionMensual (mes, nombreactivofami, marca, depreciacion_mensual, depreciacion_acumulada, valor_en_libro)
    SELECT 
        DATE_FORMAT(fecha_adquisicion, '%d de %M del %Y') AS mes,
        af.nombreactivofami,
        a.marca,
        0 AS depreciacion_mensual,
        0 AS depreciacion_acumulada,
        costo AS valor_en_libro
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    WHERE a.idactivo = id_activo;

    -- Insertar datos en la tabla temporal para los meses siguientes
    SET mes_actual = DATE_ADD(fecha_adquisicion, INTERVAL 1 MONTH);
    SET mes_final = DATE_ADD(fecha_adquisicion, INTERVAL vida_util YEAR);

    WHILE mes_actual <= mes_final DO
        SET depreciacion_acumulada = depreciacion_acumulada + depreciacion_mensual;
        SET valor_en_libro = costo - depreciacion_acumulada;

        INSERT INTO DepreciacionMensual (mes, nombreactivofami, marca, depreciacion_mensual, depreciacion_acumulada, valor_en_libro)
        SELECT 
            DATE_FORMAT(mes_actual, '%d de %M del %Y') AS mes,
            af.nombreactivofami,
            a.marca,
            depreciacion_mensual,
            depreciacion_acumulada,
            valor_en_libro
        FROM activo a
        JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
        WHERE a.idactivo = id_activo;

        SET mes_actual = DATE_ADD(mes_actual, INTERVAL 1 MONTH);
    END WHILE;

    -- Seleccionar los resultados
    SELECT * FROM DepreciacionMensual;

    -- Limpiar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS DepreciacionMensual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `graficar_depreciacion` (IN `id_activo` INT)   BEGIN
    DECLARE fecha DATE;
    DECLARE vida_util INT;
    DECLARE tasa_depreciacion DECIMAL(5,2);
    DECLARE costo DECIMAL(10,2);
    DECLARE valor_residual DECIMAL(10,2);
    DECLARE depreciacion_anual DECIMAL(10,2);
    DECLARE valor_libro DECIMAL(10,2);
    DECLARE anio_actual DATE;

    -- Obtener los datos del activo
    SELECT 
        a.fecha_adquisicion,
        ac.vida_util,
        ac.tasa_depreciacion,
        a.costo,
        a.valor_residual
    INTO 
        fecha,
        vida_util,
        tasa_depreciacion,
        costo,
        valor_residual
    FROM activo a
    JOIN activofamilia af ON a.idactivofamilia = af.idactivofamilia
    JOIN activocategoria ac ON af.idactivocategoria = ac.idactivocategoria
    WHERE a.idactivo = id_activo;

    -- Calcular la depreciación anual
    SET depreciacion_anual = (costo - valor_residual) * (tasa_depreciacion / 100);
    SET valor_libro = costo;

    -- Crear una tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS ValorLibroAnual (
        fecha VARCHAR(40),
        valor_libro DECIMAL(10,2)
    );

    -- Limpiar la tabla temporal
    TRUNCATE TABLE ValorLibroAnual;

    -- Insertar el valor inicial del Año 0
    INSERT INTO ValorLibroAnual (fecha, valor_libro)
    VALUES (DATE_FORMAT(fecha, '%d de %M del %Y'), valor_libro);

    -- Calcular y almacenar el valor en libro para cada año
    WHILE valor_libro > valor_residual DO
        SET anio_actual = DATE_ADD(fecha, INTERVAL 1 YEAR);
        SET fecha = anio_actual;
        SET valor_libro = valor_libro - depreciacion_anual;

        INSERT INTO ValorLibroAnual (fecha, valor_libro)
        VALUES (DATE_FORMAT(anio_actual, '%d de %M del %Y'), valor_libro);
    END WHILE;

    -- Seleccionar los resultados
    SELECT * FROM ValorLibroAnual;

    -- Limpiar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS ValorLibroAnual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerResumenActivos` ()   BEGIN
    SELECT 
        fa.nombreactivofami AS "Familia de Activos", 
        COUNT(a.idactivo) AS "Cantidad de Activos", 
        SUM(a.costo) AS "Total en Dinero"
    FROM 
        activofamilia fa
    LEFT JOIN 
        activo a ON fa.idactivofamilia = a.idactivofamilia
    GROUP BY 
        fa.nombreactivofami
    HAVING 
        COUNT(a.idactivo) > 0

    UNION ALL

    SELECT 
        'Total General' AS "Familia de Activos", 
        NULL AS "Cantidad de Activos", 
        SUM(a.costo) AS "Total en Dinero"
    FROM 
        activo a

    ORDER BY 
        CASE 
            WHEN "Familia de Activos" = 'Total General' THEN 1
            ELSE 0
        END, 
        "Cantidad de Activos" DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activo`
--

CREATE TABLE `activo` (
  `idactivo` int(11) NOT NULL,
  `idempresa` int(11) DEFAULT NULL,
  `idactivofamilia` int(11) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `marca` varchar(25) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `serie` varchar(100) DEFAULT NULL,
  `costo` decimal(10,2) NOT NULL,
  `fecha_adquisicion` date NOT NULL,
  `valor_residual` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `activo`
--

INSERT INTO `activo` (`idactivo`, `idempresa`, `idactivofamilia`, `descripcion`, `marca`, `modelo`, `serie`, `costo`, `fecha_adquisicion`, `valor_residual`) VALUES
(4, 1, 16, 'h', 'HP', 'bb', 'bb', 1200.00, '2024-08-08', 55.00),
(7, 1, 5, 'Recursos humanos', 'Epson', 'mk', 'mjji8', 2000.00, '2020-02-03', 0.00),
(11, 1, 1, 'Escuela', 'Mercedez', 'Benz', '', 75000.00, '2024-08-06', 200.00),
(14, 1, 76, 'Local', '', '', '', 50000.00, '2022-03-08', 0.00),
(15, 1, 29, 'Area de cafeteria', 'Mabe', '', '', 250.00, '2024-08-10', 0.00),
(16, 1, 46, 'Para oficina del jefe', '', '', '', 100.00, '2024-08-10', 0.00),
(17, 1, 69, 'Laptop para programador', 'Acer', 'Swift X', '', 950.00, '2023-02-02', 0.00),
(18, 1, 27, 'Aire acondicionado oficina principal', 'Carrier', '', '', 1200.00, '2024-08-09', 0.00),
(19, 1, 68, 'Para oficina del jefe', 'Epson', 'X', '', 800.00, '2023-07-17', 0.00),
(20, 1, 65, 'Para oficina principal', 'Digital Solutions', '', '', 400.00, '2024-08-04', 0.00),
(21, 1, 71, 'Para oficina principal', 'fORZA', 'NT-751', '', 150.00, '2022-03-08', 0.00),
(22, 1, 47, 'Sala de espera', 'Miller', '', '', 800.96, '2024-08-13', 0.00),
(24, 1, 1, 'Transporte de mantenimiento', 'Toyota', 'Hilux', '', 75000.00, '2024-08-01', 0.00),
(28, 1, 16, 'Para oficina del jefe', 'HP', 'bb', 'bb', 120034.00, '2024-08-18', 56.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activocategoria`
--

CREATE TABLE `activocategoria` (
  `idactivocategoria` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `nombreactivocat` varchar(50) NOT NULL,
  `tasa_depreciacion` decimal(5,2) NOT NULL,
  `vida_util` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `activocategoria`
--

INSERT INTO `activocategoria` (`idactivocategoria`, `codigo`, `nombreactivocat`, `tasa_depreciacion`, `vida_util`) VALUES
(1, '12101', 'EQUIPO DE TRANSPORTE', 20.00, 5),
(2, '12102', 'EQUIPO MEDICO', 20.00, 5),
(3, '12104', 'EQUIPO DE OFICINA', 20.00, 5),
(4, '12105', 'EQUIPO DE SEGURIDAD', 20.00, 5),
(5, '12107', 'EQUIPO ELECTROMECANICO', 20.00, 5),
(6, '12110', 'MOBILIARIO DE OFICINA', 20.00, 5),
(7, '12112', 'VARIOS', 20.00, 5),
(8, '12115', 'INSTALACIONES ESPECIALES', 20.00, 5),
(9, '12103', 'EQUIPO DE COMPUTACION', 33.33, 3),
(10, '12106', 'EQUIPO TELEFONICO', 33.33, 3),
(11, '12113', 'EDIFICACIONES', 5.00, 20);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activofamilia`
--

CREATE TABLE `activofamilia` (
  `idactivofamilia` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `nombreactivofami` varchar(50) NOT NULL,
  `idactivocategoria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `activofamilia`
--

INSERT INTO `activofamilia` (`idactivofamilia`, `codigo`, `nombreactivofami`, `idactivocategoria`) VALUES
(1, '01', 'Equipo de transporte', 1),
(2, '01', 'Equipo e instrumentos médicos ', 2),
(3, '01', 'Máquina de escribir', 3),
(4, '02', 'Contómetros y Calculadoras', 3),
(5, '03', 'Fotocopiadora', 3),
(6, '04', 'Anilladora', 3),
(7, '05', 'Guillotina', 3),
(8, '06', 'Reloj Marcador', 3),
(9, '07', 'Destructoras de papel', 3),
(10, '08', 'Protectora de cheques', 3),
(11, '09', 'Retroproyector', 3),
(12, '10', 'Aparatos de vídeo', 3),
(13, '11', 'Aparatos de sonido', 3),
(14, '99', 'Varios', 3),
(15, '01', 'Cámaras CCTV', 4),
(16, '02', 'Monitor CCTV', 4),
(17, '03', ' Alarmas', 4),
(18, '04', ' Detectores de humo', 4),
(19, '05', 'Chapas de seguridad', 4),
(20, '06', 'Cajas fuertes', 4),
(21, '07', 'Armas', 4),
(22, '08', 'Extintores', 4),
(23, '09', 'Chalecos contrabalas', 4),
(24, '10', 'Lámparas de emergencia', 4),
(25, '99', 'Varios', 4),
(26, '01', 'Enfriadores de agua', 5),
(27, '02', 'Sistemas y aparatos de aire \r\nacondicionados\r\n', 5),
(28, '03', 'Refrigeradoras', 5),
(29, '04', 'Cafeteras', 5),
(30, '05', 'Cocinas', 5),
(31, '06', 'Ventiladores', 5),
(32, '07', 'Planta de emergencia\r\n', 5),
(33, '08', 'Ascensores', 5),
(34, '09', 'Bombas de agua', 5),
(35, '10', 'Hornos', 5),
(36, '11', 'Transferencia automática y tableros', 5),
(37, '12', 'Transformadores secos', 5),
(38, '13', 'Herramienta eléctrica', 5),
(39, '99', 'Varios', 5),
(40, '01', 'Archivadores', 6),
(41, '02', 'Sillas, Sillones, bancos', 6),
(42, '03', 'Libreras', 6),
(43, '04', 'Credenzas', 6),
(44, '05', 'Burós', 6),
(45, '06', 'Estantes', 6),
(46, '07', 'Mesas', 6),
(47, '08', 'Muebles de sala', 6),
(48, '09', 'Portasacos', 6),
(49, '10', 'Divisiones modulares', 6),
(50, '11', 'Escritorios', 6),
(51, '13', 'Mueble para computadora', 6),
(52, '14', 'Pupitres', 6),
(53, '15', 'Estaciones Tipo', 6),
(54, '16', 'Pantry y alacenas de cocina', 6),
(55, '17', 'Objetos decorativos', 6),
(56, '18', 'Cuadros y esculturas', 6),
(57, '19', 'Vidrios bocelados', 6),
(58, '20', 'Cortinas', 6),
(59, '21', 'Pizarras, carteleras, rotafolio y \r\npantallas', 6),
(60, '99', 'Varios', 6),
(61, '01', 'Varios', 7),
(62, '01', 'Instalaciones de cable de red', 8),
(63, '02', 'Instalaciones de eléctricas', 8),
(64, '03', 'Instalaciones telefónicas', 8),
(65, '04', 'Instalaciones eléctricas Informática', 8),
(66, '05', 'Instalaciones de CCTV y Alarmas', 8),
(67, '01', 'Monitores', 9),
(68, '02', 'Impresores', 9),
(69, '03', 'CPU/ Computadoras portátiles', 9),
(70, '06', ' SPS', 9),
(71, '05', 'UPS', 9),
(72, '07', 'Regulador de Voltaje', 9),
(73, '99', 'Varios', 9),
(74, '01', 'Teléfonos, radios, Viper y plantas', 10),
(75, '02', 'Fax', 10),
(76, '01', 'Edificio', 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `idempresa` int(11) NOT NULL,
  `nombre_empresa` varchar(100) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `logo` varchar(250) DEFAULT NULL,
  `mision` text NOT NULL,
  `vision` text NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`idempresa`, `nombre_empresa`, `direccion`, `telefono`, `email`, `logo`, `mision`, `vision`, `descripcion`) VALUES
(1, 'DevConta', 'Santa Ana ', '2222-2222', 'devconta@finanzas.com', 'https://firebasestorage.googleapis.com/v0/b/chatgram-4c6da.appspot.com/o/logo1.jpeg?alt=media&token=9ad45dd5-62ae-4892-93e1-677b3afa4af4', 'Nuestra misión es proporcionar herramientas tecnológicas accesibles y efectivas que mejoren la administración contable de nuestros clientes. Nos enfocamos en entender sus necesidades y ofrecer soluciones que faciliten su día a día, permitiéndoles concentrarse en el crecimiento de sus negocios.', 'Aspiramos a ser reconocidos en El Salvador como un aliado confiable para las pequeñas y medianas empresas en la gestión contable, creciendo junto a nuestros clientes mientras mejoramos y ampliamos nuestras capacidades técnicas.', 'DevConta es una empresa emergente en El Salvador, especializada en el desarrollo de soluciones contables y administrativas. Nos dedicamos a ofrecer servicios que simplifican la gestión financiera para pequeñas y medianas empresas, ayudando a nuestros clientes a manejar sus finanzas de manera más eficiente y con un enfoque personalizado.');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `activo`
--
ALTER TABLE `activo`
  ADD PRIMARY KEY (`idactivo`),
  ADD KEY `idempresa` (`idempresa`),
  ADD KEY `idactivofamilia` (`idactivofamilia`);

--
-- Indices de la tabla `activocategoria`
--
ALTER TABLE `activocategoria`
  ADD PRIMARY KEY (`idactivocategoria`);

--
-- Indices de la tabla `activofamilia`
--
ALTER TABLE `activofamilia`
  ADD PRIMARY KEY (`idactivofamilia`),
  ADD KEY `idactivocategoria` (`idactivocategoria`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idempresa`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `activo`
--
ALTER TABLE `activo`
  MODIFY `idactivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `activocategoria`
--
ALTER TABLE `activocategoria`
  MODIFY `idactivocategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `activofamilia`
--
ALTER TABLE `activofamilia`
  MODIFY `idactivofamilia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idempresa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activo`
--
ALTER TABLE `activo`
  ADD CONSTRAINT `activo_ibfk_1` FOREIGN KEY (`idempresa`) REFERENCES `empresa` (`idempresa`),
  ADD CONSTRAINT `activo_ibfk_2` FOREIGN KEY (`idactivofamilia`) REFERENCES `activofamilia` (`idactivofamilia`);

--
-- Filtros para la tabla `activofamilia`
--
ALTER TABLE `activofamilia`
  ADD CONSTRAINT `activofamilia_ibfk_1` FOREIGN KEY (`idactivocategoria`) REFERENCES `activocategoria` (`idactivocategoria`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
