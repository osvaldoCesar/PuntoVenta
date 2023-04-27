-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-04-2023 a las 03:15:01
-- Versión del servidor: 10.3.16-MariaDB
-- Versión de PHP: 7.2.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- Volcando estructura de base de datos para punto_venta
DROP DATABASE IF EXISTS `punto_venta`;
CREATE DATABASE IF NOT EXISTS `punto_venta` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `punto_venta`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `punto_venta`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Archivo_setRegistrarArchivo` (IN `cpath` VARCHAR(255), IN `cfilename` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	INSERT INTO files (path, filename, created_by, updated_by, created_at, updated_at)
				VALUES	(cpath, cfilename, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdFile := (SELECT	((IFNULL(MAX(image.id), 1)))
	FROM		files image);

	/*RETORNAMOS*/
	SELECT	@nIdFile	AS	nIdFile;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_getListarCategorias` (IN `nidcategoria` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT)  BEGIN
	SELECT	categoria.id,
				categoria.name,
				categoria.description
	FROM		categories categoria
	WHERE		CONCAT_WS(' ', categoria.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', categoria.description)	LIKE	CONCAT('%', cdescripcion, '%')
				AND	(categoria.id	=	nidcategoria	OR	nidcategoria	=	0)
	ORDER BY categoria.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_setEditarCategoria` (IN `nidcategoria` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidauthuser` INT)  BEGIN
	UPDATE	categories
	SET		name			=	cnombre,
				description	=	cdescripcion,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_setRegistrarCategoria` (IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidauthuser` INT)  BEGIN
	INSERT	INTO	categories	(name, description, created_by, updated_by, created_at, updated_at)
							VALUES	(cnombre, cdescripcion, nidauthuser, nidauthuser, NOW(), NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_getListarContactos` (IN `nidauthuser` INT)  BEGIN
	SELECT	usuario.id,
				CONCAT_WS(' ', usuario.firstname, usuario.lastname)	AS	fullname,
				IFNULL(imagen.path, '')	AS	profile_imagen,
				(
					SELECT	COUNT(mensaje.id)
					FROM		messages	mensaje
					WHERE		mensaje.`to`	=	nidauthuser
								AND	mensaje.`from`	=	usuario.id
								AND	mensaje.`read`	=	0
				)	AS	nNumeroMensajeNoLeidos,
				(
					SELECT	mensaje.text

					FROM		messages	mensaje
					WHERE		mensaje.`to`	=	nidauthuser
								AND	mensaje.`from`	=	usuario.id
								AND	mensaje.`read`	=	0
					ORDER	BY	mensaje.id	ASC
					LIMIT	1
				)	AS	cUltimoMensajeNoLeido
	FROM		users	usuario
				LEFT OUTER JOIN	files	imagen	ON	usuario.file_id	=	imagen.id
	WHERE		usuario.id	NOT	IN	(nidauthuser);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_getListarConversaciones` (IN `nidcontacto` INT, IN `nidauthuser` INT)  BEGIN
	UPDATE	messages
	SET		`read`			=	1,
				`updated_at`	=	NOW()
	WHERE		`from`			=	nidcontacto
				AND	`to`		=	nidauthuser;

	SELECT	mensaje.`*`,
				CONCAT_WS(' ', usu_from.firstname, usu_from.lastname)	AS	usu_from_fullname,
				IFNULL(usu_from_image.path, '')	AS	usu_from_profile_image,
				CONCAT_WS(' ', usu_to.firstname, usu_to.lastname)	AS	usu_to_fullname,
				IFNULL(usu_to_image.path, '')	AS	usu_to_profile_image

	FROM		messages	mensaje
				INNER	JOIN	users	usu_to					ON	mensaje.`to`		=	usu_to.id
				INNER	JOIN	users	usu_from					ON	mensaje.`from`		=	usu_from.id
				LEFT OUTER JOIN	files	usu_to_image	ON	usu_to.file_id		=	usu_to_image.id
				LEFT OUTER JOIN	files	usu_from_image	ON	usu_from.file_id	=	usu_from_image.id
	WHERE		(mensaje.`from`	=	nidauthuser		AND	mensaje.`to`	=	nidcontacto)
				OR	(mensaje.`from`	=	nidcontacto	AND	mensaje.`to`	=	nidauthuser);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_setRegistrarMensaje` (IN `from` INT, IN `to` INT, IN `text` VARCHAR(191))  BEGIN
	set names utf8mb4;

	INSERT	INTO	messages	(`from`, `to`, `text`, created_at, updated_at)
						VALUES	(`from`, `to`, text, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdMensaje := (SELECT	((IFNULL(MAX(mensaje.id), 1)))
	FROM		messages mensaje);

	SELECT	mensaje.`*`,
				CONCAT_WS(' ', usu_from.firstname, usu_from.lastname)	AS	usu_from_fullname,
				IFNULL(usu_from_image.path, '')	AS	usu_from_profile_image,
				CONCAT_WS(' ', usu_to.firstname, usu_to.lastname)	AS	usu_to_fullname,
				IFNULL(usu_to_image.path, '')	AS	usu_to_profile_image

	FROM		messages	mensaje
				INNER	JOIN	users	usu_to					ON	mensaje.`to`		=	usu_to.id
				INNER	JOIN	users	usu_from					ON	mensaje.`from`		=	usu_from.id
				LEFT OUTER JOIN	files	usu_to_image	ON	usu_to.file_id		=	usu_to_image.id
				LEFT OUTER JOIN	files	usu_from_image	ON	usu_from.file_id	=	usu_from_image.id
	WHERE		mensaje.id	=	@nIdMensaje;

	set names utf8mb4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Dashboard_getProductosMasVendidos` ()  BEGIN
	SELECT	producto.id,
				producto.name,
				(
					SELECT	SUM(detalle.quantity)
					FROM		details_orders	detalle
					WHERE		detalle.product_id	=	producto.id
				)	AS	cantidad
	FROM		products	producto
	ORDER	BY	cantidad DESC
	LIMIT	5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Dashboard_getVentasPorDia` ()  BEGIN
	SELECT	SUM(pedido.total)	AS	total,
				DAY(pedido.created_at)	AS	dia
	FROM		orders	pedido
	WHERE		MONTH(pedido.created_at)	=	MONTH(NOW())
	GROUP	BY	dia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_getListarDoctores` (IN `niddoctor` INT, IN `ddni` VARCHAR(50), IN `dnombre` VARCHAR(50), IN `drfc` VARCHAR(50))  BEGIN
	SELECT	doctor.id,
				doctor.dni,
				CONCAT_WS(' ', doctor.name, doctor.lastname)	AS	fullname,
				doctor.name,
				doctor.lastname,
				doctor.rfc,
				doctor.email,
				doctor.phone
	FROM		doctors	doctor
	WHERE		CONCAT_WS(' ', doctor.name, doctor.lastname)	LIKE	CONCAT('%', dnombre, '%')
				AND	doctor.dni	LIKE	CONCAT('%', ddni, '%')
				AND	doctor.rfc	LIKE	CONCAT('%', drfc, '%')
				AND	(doctor.id	=	niddoctor	OR	niddoctor = 0)
	ORDER	BY	doctor.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_getNuevoDniDoctor` ()  BEGIN
	SET @nDniDoctor := (SELECT IF(ISNULL(id), 'D00001', CONCAT('D', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM doctors);

	/*RETORNAMOS*/
	SELECT	@nDniDoctor	AS	nDniDoctor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_setEditarDoctor` (IN `niddoctor` INT, IN `drfc` VARCHAR(50), IN `dnombre` VARCHAR(50), IN `dapellido` VARCHAR(50), IN `demail` VARCHAR(50), IN `dtelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	UPDATE	doctors
	SET		rfc			=	drfc,
				name			=	dnombre,
				lastname		=	dapellido,
				email			=	demail,
				phone			=	dtelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	niddoctor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_setRegistrarDoctor` (IN `drfc` VARCHAR(50), IN `dnombre` VARCHAR(50), IN `dapellido` VARCHAR(50), IN `demail` VARCHAR(50), IN `dtelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	SET @nDniDoctor := (SELECT IF(ISNULL(id), 'D00001', CONCAT('D', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM doctors);
	INSERT	INTO	doctors	(dni, rfc, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(@nDniDoctor, drfc, dnombre, dapellido, demail, dtelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdDoctor := (SELECT	((IFNULL(MAX(doctor.id), 1)))
	FROM		doctors doctor);

	/*RETORNAMOS*/
	SELECT	@nIdDoctor	AS	nIdDoctor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_getListarPacientes` (IN `nidpaciente` INT, IN `niddoctor` INT, IN `pnombre` VARCHAR(50), IN `pdni` VARCHAR(50))  BEGIN
	SELECT	paciente.id,
				paciente.dni,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	fullname,
				paciente.name,
				paciente.lastname,
				paciente.document,
				paciente.email,
				paciente.phone
	FROM		patients	paciente, doctors doctor
	WHERE		paciente.doctor_id  =   niddoctor
                AND paciente.doctor_id  =   doctor.id
                AND CONCAT_WS(' ', paciente.name, paciente.lastname)	LIKE	CONCAT('%', pnombre, '%')
				AND	paciente.dni	LIKE	CONCAT('%', pdni, '%')
				AND	(paciente.id	=	nidpaciente	OR	nidpaciente = 0)
	ORDER	BY	paciente.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_getNuevoDniPaciente` ()  BEGIN
	SET @nDniPaciente := (SELECT IF(ISNULL(id), 'P00001', CONCAT('P', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM patients);

	/*RETORNAMOS*/
	SELECT	@nDniPaciente	AS	nDniPaciente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_setEditarPaciente` (IN `nidpaciente` INT, IN `cdocumento` VARCHAR(50), IN `cnombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cemail` VARCHAR(50), IN `ctelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	UPDATE	patients
	SET		document		=	cdocumento,
				name			=	cnombre,
				lastname		=	capellido,
				email			=	cemail,
				phone			=	ctelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidpaciente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_setRegistrarPaciente` (IN `niddoctor` INT, IN `cdocumento` VARCHAR(50), IN `cnombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cemail` VARCHAR(50), IN `ctelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	SET @nDniPaciente := (SELECT IF(ISNULL(id), 'P00001', CONCAT('P', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM patients);

	INSERT	INTO	patients	(doctor_id, dni, document, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(niddoctor, @nDniPaciente, cdocumento, cnombre, capellido, cemail, ctelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdPaciente := (SELECT	((IFNULL(MAX(paciente.id), 1)))
	FROM		patients paciente);

	/*RETORNAMOS*/
	SELECT	@nIdPaciente	AS	nIdPaciente;
END$$

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getDetallePedido
DROP PROCEDURE IF EXISTS `sp_Pedido_getDetallePedido`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getDetallePedido`(IN `nidpedido` INT)
BEGIN
	SELECT	producto.id,
				producto.name				AS	cProducto,
				detalle_pedido.quantity	AS	nCantidad,
				detalle_pedido.price		AS	fPrecio,
				(detalle_pedido.quantity * detalle_pedido.price)	AS	fSubTotal,
				detalle_pedido.discount		AS	fDescuento,
				((detalle_pedido.quantity * detalle_pedido.price) - detalle_pedido.discount)	AS	fTotal,
                categoria.name	AS	categoria
	FROM		orders	pedido
				INNER	JOIN	details_orders	detalle_pedido	ON	pedido.id	=	detalle_pedido.order_id
				INNER	JOIN	products			producto			ON	detalle_pedido.product_id	=	producto.id
                INNER JOIN categories categoria	ON	producto.categorie_id = categoria.id
	WHERE		pedido.id	=	nidpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarAbonoPedidos` (IN `nidpedido` INT)  BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				(
					SELECT	SUM(detalle_venta.price)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor,
				abono.credit	AS	abonos,
				DATE_FORMAT(abono.created_at,'%d-%m-%Y %r')	AS	fecha,
				abono.comments	AS	comentario
	FROM		payments		abono
				INNER	JOIN	users		vendedor		ON	abono.created_by		=	vendedor.id
				INNER	JOIN	orders	pedido		ON	abono.order_id			=	pedido.id
	WHERE		pedido.id	=	nidpedido
	ORDER	BY	pedido.order_number	DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarPedidos` (IN `dDni` VARCHAR(50), IN `tDni` VARCHAR(50), IN `cPedido` VARCHAR(50), IN `cEstado` CHAR(1), IN `dFechaCita` VARCHAR(50))  BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				paciente.document		AS	documento,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	paciente,
                paciente.dni			AS	dniPaciente,
				tecnico.rfc				AS	rfcTechnical,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	tecnico,
                tecnico.dni				AS	dniTecnico,
				CONCAT_WS(' ', doctor.name, doctor.lastname)	AS	doctor,
                doctor.dni				AS	dniDoctor,
				(
					SELECT	SUM(detalle_venta.price) - SUM(detalle_venta.discount)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	doctors	doctor	ON	doctor.id	=	paciente.doctor_id
				INNER	JOIN	technicals	tecnico	ON	pedido.technical_id	=	tecnico.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		doctor.dni	LIKE	CONCAT('%', dDni, '%')
				AND tecnico.dni	LIKE	CONCAT('%', tDni, '%')
				AND	pedido.order_number	LIKE	CONCAT('%', cPedido, '%')
				AND	(pedido.state	=	cEstado	OR	cEstado	=	'')
				AND	(DATE(pedido.fecha_cita)	Like CONCAT('%', dFechaCita, '%')	OR	(dFechaCita	=	''))
	ORDER	BY	pedido.order_number	DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarTotales` (IN `nidpedido` INT)  BEGIN
	SELECT
			(SELECT total FROM orders pedido WHERE pedido.id=nidpedido) AS totalPedido,
			IFNULL(SUM(abonos.credit), 0) AS totalAbonos,
			(SELECT total FROM orders pedido WHERE pedido.id=nidpedido) - IFNULL(SUM(abonos.credit), 0) AS restante
	FROM orders pedidos, payments abonos
	WHERE abonos.order_id = pedidos.id AND abonos.order_id=nidpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getPedido` (IN `nidpedido` INT)  BEGIN
	SELECT	pedido.id,
				pedido.order_number		AS	nNumeroPedido,
				DATE_FORMAT(pedido.created_at,'%d-%m-%Y %r')			AS	dFechaPedido,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'GENERADO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	cEstadoPedido,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	cVendedor,
				vendedor.email	AS	cVendedorCorreo,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	pPaciente,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	tTechnical,
				CONCAT_WS(' ', doctor.name, doctor.lastname)	AS	dDoctor,
				doctor.rfc					AS	dRfc,
				IFNULL(doctor.phone, '')		AS	dTelefono,
				IFNULL(doctor.email, '')		AS	dCorreo,
				pedido.total						AS	fTotalPedido,
				IFNULL(pedido.comments, '')	AS	cComentario,
				DATE_FORMAT(pedido.fecha_cita,'%d-%m-%Y %r') AS dFechaCita
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	doctors doctor	ON	paciente.doctor_id	=	doctor.id
				INNER	JOIN	technicals	tecnico	ON	pedido.technical_id	=	tecnico.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		pedido.id	=	nidpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setCambiarEstadoPedido` (IN `nidpedido` INT, IN `cestado` CHAR(1), IN `nidauthuser` INT)  BEGIN
	UPDATE	orders
	SET		state			=	cestado,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarAbono` (IN `nidpedido` INT, IN `fabono` DOUBLE, IN `ccomentario` TEXT, IN `nidauthuser` INT)  BEGIN
	INSERT	INTO	payments	(comments, credit, order_id, created_by, created_at)
							VALUES	(ccomentario, fabono, nidpedido, nidauthuser, NOW());

	SET @resultado	:=	(SELECT ((SELECT total FROM orders pedido WHERE pedido.id=nidpedido) - IFNULL(SUM(abonos.credit), 0))
							FROM orders pedidos, payments abonos
							WHERE abonos.order_id = pedidos.id AND abonos.order_id=nidpedido);

	if @resultado<=0 then
    	UPDATE orders pedidos SET pedidos.state='L' WHERE pedidos.id = nidpedido;
	end if;

	SELECT	@resultado	AS	resultado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarDetallePedido` (IN `nidpedido` INT, IN `nidproducto` INT, IN `nstock` INT, IN `fsubtotal` DOUBLE, IN `fdescuento` DOUBLE)  BEGIN
	INSERT	INTO	details_orders	(order_id, product_id, quantity, price, discount)
								VALUES	(nidpedido, nidproducto, nstock, fsubtotal, fdescuento);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarPedido` (IN `nidpaciente` INT, IN `nidtechnical` INT, IN `ccomentario` TEXT, IN `ftotalpedido` DOUBLE, IN `dfechacita` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	/*Generar el número del pedido*/
	SET @nOrderName := (SELECT	CONCAT_WS('', YEAR(NOW()), MONTH(NOW()), DAY(NOW())));

	INSERT	INTO	orders	(comments, patient_id, user_id, technical_id, total, created_by, updated_by, created_at, updated_at, fecha_cita)
						VALUES	(ccomentario, nidpaciente, nidauthuser, nidtechnical, ftotalpedido, nidauthuser, nidauthuser, NOW(), NOW(), dfechacita);

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdPedido := (SELECT	((IFNULL(MAX(pedido.id), 1)))
	FROM		orders pedido);

	/*ACTUALIZAR EL NUMERO DEL PEDIDO*/
	UPDATE	orders
	SET		order_number	=	CONCAT_WS('', @nOrderName, @nIdPedido)
	WHERE		id					=	@nIdPedido;

	/*RETORNAMOS*/
	SELECT	@nIdPedido	AS	nIdPedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_getListarPermisos` (IN `nidpermiso` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name
	FROM		permissions permiso
	WHERE		CONCAT_WS(' ', permiso.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', permiso.slug)	LIKE	CONCAT('%', cslug, '%')
				AND	(permiso.id	=	nidpermiso	OR	nidpermiso = 0)
	ORDER BY permiso.name DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_setEditarPermiso` (IN `nidpermiso` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	UPDATE	permissions
	SET		name			=	cnombre,
				slug			=	cslug,
				updated_at	=	NOW()
	WHERE		id				=	nidpermiso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_setRegistrarPermiso` (IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	INSERT	INTO	permissions	(name, slug, created_at, updated_at)
							VALUES	(cnombre, cslug, NOW(), NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_getListarProductos` (IN `nidproducto` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidcategoria` INT)  BEGIN
	SELECT	producto.id,
				producto.name,
				producto.description,
				producto.stock,
				producto.price,
				categoria.id	AS	nidcategoria,
				categoria.name	AS	categoria
	FROM		products producto
				INNER JOIN categories categoria	ON	producto.categorie_id = categoria.id
	WHERE		CONCAT_WS(' ', producto.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', producto.description)	LIKE	CONCAT('%', cdescripcion, '%')
				AND	(producto.id	=	nidproducto	OR	nidproducto	=	0)
				AND	(categoria.id	=	nidcategoria	OR	nidcategoria	=	0)
	ORDER BY producto.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_setEditarProducto` (IN `nidproducto` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nstock` INT, IN `fprecio` DOUBLE, IN `nidcategoria` INT, IN `nidauthuser` INT)  BEGIN
	UPDATE	products
	SET		name				=	cnombre,
				description		=	cdescripcion,
				stock				=	nstock,
				price				=	fprecio,
				categorie_id	=	nidcategoria,
				updated_by		=	nidauthuser,
				updated_at		=	NOW()
	WHERE		id					=	nidproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_setRegistrarProducto` (IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nstock` INT, IN `fprecio` DOUBLE, IN `nidcategoria` INT, IN `nidauthuser` INT)  BEGIN
	INSERT	INTO	products	(name, description, stock, price, categorie_id, created_by, updated_by, created_at, updated_at)
						VALUES	(cnombre, cdescripcion, nstock, fprecio, nidcategoria, nidauthuser, nidauthuser, NOW(), NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Reporte_getListarPedidos` (IN `cNombre` VARCHAR(50), IN `cDocumento` VARCHAR(50), IN `cPedido` VARCHAR(50), IN `cEstado` CHAR(1), IN `dFechaInicio` VARCHAR(50), IN `dFechaFin` VARCHAR(50))  BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				paciente.document		AS	documento,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	paciente,
				(
					SELECT	SUM(detalle_venta.price)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
																			ELSE	'RECHAZADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		CONCAT_WS(' ', paciente.name, paciente.lastname)	LIKE	CONCAT('%', cNombre, '%')
				AND	paciente.document	LIKE	CONCAT('%', cDocumento, '%')
				AND	pedido.order_number	LIKE	CONCAT('%', cPedido, '%')
				AND	(pedido.state	=	cEstado	OR	cEstado	=	'')
				AND	((DATE(pedido.created_at)	BETWEEN	dFechaInicio	AND	dFechaFin)	OR	(dFechaInicio	=	''	AND	dFechaFin = ''))
	ORDER	BY	pedido.order_number	DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_getListarPermisosByRol` (IN `nidrol` INT)  BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name,
				CASE	IFNULL(rol_permiso.role_id, '')	WHEN	''	THEN	0
																				ELSE	1
																				END	checked
	FROM		permissions	permiso
				LEFT OUTER JOIN	roles_permissions	rol_permiso	ON	permiso.id	=	rol_permiso.permission_id
																					AND	rol_permiso.role_id	=	nidrol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_getListarRoles` (IN `nidrol` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	SELECT	rol.id,
				rol.slug,
				rol.name
	FROM		roles rol
	WHERE		CONCAT_WS(' ', rol.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', rol.slug)	LIKE	CONCAT('%', cslug, '%')
				AND	(rol.id	=	nidrol	OR	nidrol = 0)
	ORDER BY rol.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setEditarRol` (IN `nidrol` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	UPDATE	roles
	SET		name			=	cnombre,
				slug			=	cslug,
				updated_at	=	NOW()
	WHERE		id				=	nidrol;


	DELETE
	FROM		roles_permissions
	WHERE		role_id	=	nidrol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setRegistrarRol` (IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))  BEGIN
	INSERT	INTO	roles	(name, slug, created_at, updated_at)
					VALUES	(cnombre, cslug, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdRol := (SELECT	((IFNULL(MAX(rol.id), 1)))
	FROM		roles rol);

	/*RETORNAMOS*/
	SELECT	@nIdRol	AS	nIdRol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setRegistrarRolPermiso` (IN `nidrol` INT, IN `nidpermiso` INT)  BEGIN
	INSERT INTO roles_permissions	(role_id, permission_id)
								VALUES	(nidrol, nidpermiso);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_getListarTecnicos` (IN `nidtechnical` INT, IN `tdni` VARCHAR(50), IN `tnombre` VARCHAR(50), IN `trfc` VARCHAR(50))  BEGIN
	SELECT	tecnico.id,
                tecnico.dni,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	fullname,
				tecnico.name,
				tecnico.lastname,
				tecnico.rfc,
				tecnico.email,
				tecnico.phone
	FROM		technicals	tecnico
	WHERE		CONCAT_WS(' ', tecnico.name, tecnico.lastname)	LIKE	CONCAT('%', tnombre, '%')
				AND	tecnico.dni	LIKE	CONCAT('%', tdni, '%')
				AND	tecnico.rfc	LIKE	CONCAT('%', trfc, '%')
				AND	(tecnico.id	=	nidtechnical	OR	nidtechnical = 0)
	ORDER	BY	tecnico.id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_getNuevoDniTecnico` ()  BEGIN
	SET @nDniTecnico := (SELECT IF(ISNULL(id), 'T00001', CONCAT('T', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM technicals);

	/*RETORNAMOS*/
	SELECT	@nDniTecnico	AS	nDniTecnico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_setEditarTecnico` (IN `nidtechnical` INT, IN `trfc` VARCHAR(50), IN `tnombre` VARCHAR(50), IN `tapellido` VARCHAR(50), IN `temail` VARCHAR(50), IN `ttelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	UPDATE	technicals
	SET		rfc			=	trfc,
				name			=	tnombre,
				lastname		=	tapellido,
				email			=	temail,
				phone			=	ttelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidtechnical;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_setRegistrarTecnico` (IN `trfc` VARCHAR(50), IN `tnombre` VARCHAR(50), IN `tapellido` VARCHAR(50), IN `temail` VARCHAR(50), IN `ttelefono` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
    SET @nDniTecnico := (SELECT IF(ISNULL(id), 'T00001', CONCAT('T', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM technicals);
	INSERT	INTO	technicals	(dni, rfc, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(@nDniTecnico, trfc, tnombre, tapellido, temail, ttelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdTechnical := (SELECT	((IFNULL(MAX(technical.id), 1)))
	FROM		technicals technical);

	/*RETORNAMOS*/
	SELECT	@nIdTechnical	AS	nIdTechnical;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarPermisosByRolAsignado` (IN `nidusario` INT)  BEGIN
	SELECT	p.id,
				p.name,
				p.slug
	FROM		users_roles	ur
				INNER	JOIN	roles_permissions	rp	ON	ur.role_id			=	rp.role_id
				INNER	JOIN	permissions		p		ON	rp.permission_id	=	p.id
	WHERE		ur.user_id	=	nidusario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarPermisosByUsuario` (IN `nidusuario` INT)  BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name,
				CASE	IFNULL(user_permiso.user_id, '')	WHEN	''	THEN	0
																				ELSE	1
																				END	checked
	FROM		permissions	permiso
				LEFT OUTER JOIN	users_permissions	user_permiso	ON	permiso.id	=	user_permiso.permission_id
																					AND	user_permiso.user_id	=	nidusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarRolPermisosByUsuario` (IN `nidusuario` INT)  BEGIN
	SELECT	permiso.id,
				permiso.name,
				permiso.slug
	FROM		permissions	permiso
				INNER JOIN	users_permissions	user_permiso	ON	permiso.id	=	user_permiso.permission_id
																					AND	user_permiso.user_id	=	nidusuario

	UNION

	SELECT	p.id,
				p.name,
				p.slug
	FROM		users_roles	ur
				INNER	JOIN	roles_permissions	rp	ON	ur.role_id			=	rp.role_id
				INNER	JOIN	permissions		p		ON	rp.permission_id	=	p.id
	WHERE		ur.user_id	=	nidusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarUsuarios` (IN `nidusuario` INT, IN `cnombre` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `cestado` CHAR(1))  BEGIN
	SELECT	usuario.id,
				CONCAT_WS(' ', usuario.firstname, usuario.secondname, usuario.lastname)	AS	fullname,
				usuario.firstname,
				usuario.secondname,
				usuario.lastname,
				usuario.username,
				IFNULL(usuario.email, '')	AS	email,
				CASE	IFNULL(usuario.state, '')	WHEN	'A'	THEN	'ACTIVO'
																			ELSE	'INACTIVO'
																			END	state_alias,
				IFNULL(usuario.state, '')	AS	state,
				IFNULL(image.path, '')		AS	profile_image
	FROM		users	usuario
				LEFT OUTER JOIN files image ON usuario.file_id	=	image.id
	WHERE		CONCAT_WS(' ', usuario.firstname, usuario.secondname, usuario.lastname)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', usuario.username)	LIKE	CONCAT('%', cusuario, '%')
				AND	CONCAT_WS(' ', usuario.email)		LIKE	CONCAT('%', ccorreo, '%')
				AND	(usuario.state	=	cestado	OR	cestado	=	'')
				AND	(usuario.id		=	nidusuario	OR	nidusuario	=	0)
	ORDER	BY	usuario.id	ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getRolByUsuario` (IN `nidusuario` INT)  BEGIN
	SELECT	ur.role_id	AS	nIdRol,
				rol.name
	FROM		users_roles	ur
				INNER	JOIN	roles	rol	ON	ur.role_id	=	rol.id
	WHERE		user_id		=	nidusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setCambiarEstadoUsuario` (IN `nidusuario` INT, IN `cestado` CHAR(1), IN `nidauthuser` INT)  BEGIN
	UPDATE	users
	SET		state			=	cestado,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEditarRolByUsuario` (IN `nidusuario` INT, IN `nidrol` INT)  BEGIN
	SELECT	@nCantidadRoles :=	COUNT(role_id)
	FROM		users_roles
	WHERE		user_id		=	nidusuario;

	IF(@nCantidadRoles > 0)
		THEN
			/* ACTUALIZAR EL ROL POR USUARIO*/
			UPDATE	users_roles
			SET		role_id		=	nidrol
			WHERE		user_id		=	nidusuario;
	ELSE
		INSERT	INTO	users_roles	(user_id, role_id)
								VALUES	(nidusuario, nidrol);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEditarUsuario` (IN `nidusuario` INT, IN `cprimernombre` VARCHAR(50), IN `csegundonombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `ccontrasena` VARCHAR(150), IN `ofotografia` INT, IN `nidauthuser` INT)  BEGIN
	IF(csegundonombre = '' AND ccontrasena = '' AND ofotografia = 0)
		THEN
			UPDATE	users
			SET		firstname	=	cprimernombre,
						lastname		=	capellido,
						username		=	cusuario,
						email			=	ccorreo,
						updated_by	=	nidauthuser,
						updated_at	=	NOW()
			WHERE		id				=	nidusuario;
	ELSE
		IF(csegundonombre	= ''	AND	ccontrasena = '')
			THEN
				UPDATE	users
				SET		firstname	=	cprimernombre,
							lastname		=	capellido,
							username		=	cusuario,
							email			=	ccorreo,
							file_id		=	ofotografia,
							updated_by	=	nidauthuser,
							updated_at	=	NOW()
				WHERE		id				=	nidusuario;
		ELSE
			IF(csegundonombre	=	''	AND	ofotografia = 0)
				THEN
					UPDATE	users
					SET		firstname	=	cprimernombre,
								lastname		=	capellido,
								password		=	ccontrasena,
								username		=	cusuario,
								email			=	ccorreo,
								updated_by	=	nidauthuser,
								updated_at	=	NOW()
					WHERE		id				=	nidusuario;
			ELSE
				IF(ccontrasena	=	''	AND	ofotografia = 0)
					THEN
						UPDATE	users
						SET		firstname	=	cprimernombre,
									secondname	=	csegundonombre,
									lastname		=	capellido,
									username		=	cusuario,
									email			=	ccorreo,
									updated_by	=	nidauthuser,
									updated_at	=	NOW()
						WHERE		id				=	nidusuario;
				ELSE
					IF	(csegundonombre = '')
						THEN
							UPDATE	users
							SET		firstname	=	cprimernombre,
										lastname		=	capellido,
										password		=	ccontrasena,
										file_id		=	ofotografia,
										username		=	cusuario,
										email			=	ccorreo,
										updated_by	=	nidauthuser,
										updated_at	=	NOW()
							WHERE		id				=	nidusuario;
					ELSE
						IF(ccontrasena	=	'')
							THEN
								UPDATE	users
								SET		firstname	=	cprimernombre,
											secondname	=	csegundonombre,
											lastname		=	capellido,
											file_id		=	ofotografia,
											username		=	cusuario,
											email			=	ccorreo,
											updated_by	=	nidauthuser,
											updated_at	=	NOW()
								WHERE		id				=	nidusuario;
						ELSE
							IF(ofotografia = 0)
								THEN
									UPDATE	users
									SET		firstname	=	cprimernombre,
												secondname	=	csegundonombre,
												lastname		=	capellido,
												password		=	ccontrasena,
												username		=	cusuario,
												email			=	ccorreo,
												updated_by	=	nidauthuser,
												updated_at	=	NOW()
									WHERE		id				=	nidusuario;
							ELSE
								UPDATE	users
								SET		firstname	=	cprimernombre,
											secondname	=	csegundonombre,
											lastname		=	capellido,
											password		=	ccontrasena,
											username		=	cusuario,
											email			=	ccorreo,
											file_id		=	ofotografia,
											updated_by	=	nidauthuser,
											updated_at	=	NOW()
								WHERE		id				=	nidusuario;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEliminarPermisosByUsuario` (IN `nidusuario` INT)  BEGIN
	DELETE
	FROM		users_permissions
	WHERE		user_id	=	nidusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setRegistrarPermisosByUsuario` (IN `nidusuario` INT, IN `nidpermiso` INT)  BEGIN
	INSERT	INTO	users_permissions	(user_id, permission_id)
									VALUES	(nidusuario, nidpermiso);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setRegistrarUsuario` (IN `cprimernombre` VARCHAR(50), IN `csegundonombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `ccontrasena` VARCHAR(150), IN `ofotografia` VARCHAR(50), IN `nidauthuser` INT)  BEGIN
	insert into	users	(firstname, secondname, lastname, username, email, password, file_id, state, created_by, updated_by, created_at)
				VALUES	(cprimernombre, csegundonombre, capellido, cusuario, ccorreo, ccontrasena, ofotografia, 'A', nidauthuser, nidauthuser, NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdUsuario := (SELECT	((IFNULL(MAX(usuario.id), 1)))
	FROM		users usuario);

	/*RETORNAMOS*/
	SELECT	@nIdUsuario	AS	nIdUsuario;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(2, 'ZIRCONIO', '', 1, 1, '2023-04-12 00:45:24', '2023-04-12 00:45:24'),
(3, 'EMAX', '', 1, 1, '2023-04-12 00:45:36', '2023-04-12 00:45:36'),
(4, 'PMMA', '', 1, 1, '2023-04-12 00:45:43', '2023-04-12 00:45:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `details_orders`
--

CREATE TABLE `details_orders` (
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` smallint(6) DEFAULT 12,
  `price` double DEFAULT 12,
  `discount` double DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `details_orders`
--
DELIMITER $$
CREATE TRIGGER `tr_Pedido_setActualizarStock` AFTER INSERT ON `details_orders` FOR EACH ROW BEGIN
	UPDATE	products
	SET		stock		=	stock - NEW.quantity
	WHERE		id			=	NEW.product_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doctors`
--

CREATE TABLE `doctors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rfc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `doctors`
--

INSERT INTO `doctors` (`id`, `dni`, `name`, `lastname`, `rfc`, `phone`, `email`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'D00001', 'Susana', 'Viveros', '', '', '', 1, 1, '2023-04-12 00:44:29', '2023-04-12 00:44:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `files`
--

CREATE TABLE `files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `from` int(10) UNSIGNED NOT NULL,
  `to` int(10) UNSIGNED NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT 0,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `technical_id` bigint(20) UNSIGNED NOT NULL,
  `total` double(8,2) NOT NULL DEFAULT 0.00,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `state` enum('A','I','L') COLLATE utf8mb4_unicode_ci DEFAULT 'A',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fecha_cita` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `patients`
--

CREATE TABLE `patients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doctor_id` bigint(20) UNSIGNED NOT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `comments` text DEFAULT NULL,
  `credit` double(8,2) DEFAULT 0.00,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permissions`
--

INSERT INTO `permissions` (`id`, `slug`, `name`, `created_at`, `updated_at`) VALUES
(1, 'usuario.index', 'Navegar Usuarios', '2020-05-11 22:57:10', '2020-05-11 22:57:10'),
(2, 'usuario.crear', 'Crear Usuario', '2020-05-11 22:57:10', '2020-05-17 02:17:10'),
(3, 'usuario.editar', 'Editar Usuario', '2020-05-11 22:57:10', '2020-05-17 02:17:19'),
(4, 'usuario.ver', 'Ver Usuario', '2020-05-11 22:57:10', '2020-05-17 02:17:31'),
(5, 'usuario.activar', 'Activar Usuario', '2020-05-11 22:57:10', '2023-02-13 06:29:00'),
(6, 'usuario.desactivar', 'Desactivar Usuario', '2020-05-11 22:57:10', '2020-05-17 02:18:08'),
(7, 'rol.index', 'Navegar Roles', '2020-05-11 22:57:10', '2020-05-11 22:57:10'),
(8, 'permiso.crear', 'Crear Permiso', '2020-05-14 19:08:05', '2020-05-17 02:17:50'),
(9, 'usuario.permiso', 'Permiso Usuario', '2020-05-15 18:22:59', '2020-05-15 18:22:59'),
(10, 'rol.crear', 'Crear Rol', '2020-05-15 18:24:39', '2020-05-15 18:24:39'),
(11, 'rol.editar', 'Editar Rol', '2020-05-15 18:25:00', '2020-05-15 18:25:00'),
(12, 'rol.ver', 'Ver Rol', '2020-05-17 02:11:48', '2020-05-17 02:12:05'),
(13, 'permiso.index', 'Navegar Permiso', '2020-05-17 02:13:19', '2020-05-17 02:13:19'),
(14, 'permiso.editar', 'Editar Permiso', '2020-05-17 02:13:34', '2020-05-17 02:13:34'),
(15, 'dashboard.index', 'Navegar Dashboard', '2020-05-17 02:15:04', '2020-05-17 02:15:04'),
(16, 'pedido.index', 'Navegar Pedidos', '2020-05-17 02:15:31', '2020-05-17 02:19:29'),
(17, 'categoria.index', 'Navegar Categorias', '2020-05-17 02:16:16', '2020-05-17 02:19:07'),
(18, 'producto.index', 'Navegar Productos', '2020-05-17 02:16:26', '2020-05-17 02:18:59'),
(19, 'reporte.pedido.index', 'Navegar Reporte Pedido', '2020-05-17 02:20:19', '2020-05-17 02:20:19'),
(20, 'categoria.crear', 'Crear Categoria', '2020-05-22 23:31:16', '2020-05-22 23:31:16'),
(21, 'categoria.editar', 'Editar Categoria', '2020-05-22 23:57:29', '2020-05-22 23:57:29'),
(22, 'producto.crear', 'Crear Producto', '2020-05-24 04:39:54', '2020-05-24 04:39:54'),
(23, 'producto.editar', 'Editar Producto', '2020-05-24 04:40:02', '2020-05-24 04:40:02'),
(24, 'pedido.crear', 'Crear Pedido', '2020-05-26 02:32:47', '2020-05-26 02:32:47'),
(25, 'pedido.ver', 'Ver Pedido', '2020-05-26 02:33:51', '2020-05-26 02:33:51'),
(26, 'pedido.rechazar', 'Rechazar Pedido', '2020-05-26 02:34:09', '2020-05-26 02:34:09'),
(27, 'productos.mas.vendidos', 'Productos mas vendidos', '2020-06-02 07:12:42', '2020-06-02 07:30:19'),
(28, 'ventas.por.dia', 'Ventas por dia', '2020-06-02 07:13:16', '2020-06-02 07:30:11'),
(29, 'tecnico.index', 'Navegar Técnicos', '2023-02-10 05:10:37', '2023-02-10 05:10:37'),
(30, 'tecnico.editar', 'Editar Técnico', '2023-02-11 03:44:13', '2023-02-11 03:44:13'),
(31, 'tecnico.crear', 'Crear Técnico', '2023-02-11 03:44:21', '2023-02-11 03:44:21'),
(32, 'doctor.index', 'Navegar Doctores', '2023-02-10 05:10:37', '2023-02-10 05:10:37'),
(33, 'doctor.editar', 'Editar Doctor', '2023-02-11 03:44:13', '2023-02-11 03:44:13'),
(34, 'doctor.crear', 'Crear Doctor', '2023-02-11 03:44:21', '2023-02-11 03:44:21'),
(35, 'pedido.abonar', 'Abonar Pedido', '2023-02-16 05:08:31', '2023-02-16 05:09:45'),
(36, 'paciente.ver', 'Ver Pacientes', '2023-02-16 05:08:31', '2023-02-16 05:09:45'),
(37, 'paciente.crear', 'Crear Pacientes', '2023-02-16 05:08:31', '2023-02-16 05:09:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock` bigint(20) NOT NULL DEFAULT 10000000,
  `state` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'Y',
  `price` double(10,2) NOT NULL DEFAULT 10.50,
  `categorie_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `stock`, `state`, `price`, `categorie_id`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'Corona', '', 1, 'Y', 1300.00, 3, 1, 1, '2023-04-12 00:46:31', '2023-04-12 01:10:59'),
(2, 'Corona', '', 1, 'Y', 1300.00, 2, 1, 1, '2023-04-12 00:46:54', '2023-04-12 01:11:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `slug`, `name`, `created_at`, `updated_at`) VALUES
(2, 'rol.administrador', 'Administrador', '2020-05-11 21:45:15', '2023-02-16 05:10:45'),
(3, 'vendedor', 'Vendedor', '2020-06-02 01:23:31', '2023-02-13 06:29:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permissions`
--

CREATE TABLE `roles_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles_permissions`
--

INSERT INTO `roles_permissions` (`role_id`, `permission_id`) VALUES
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20),
(2, 21),
(2, 22),
(2, 23),
(2, 24),
(2, 25),
(2, 26),
(2, 27),
(2, 28),
(2, 29),
(2, 30),
(2, 31),
(2, 32),
(2, 33),
(2, 34),
(2, 35),
(2, 36),
(2, 37);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `technicals`
--

CREATE TABLE `technicals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rfc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `technicals`
--

INSERT INTO `technicals` (`id`, `dni`, `name`, `lastname`, `rfc`, `phone`, `email`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'T00001', 'Gaby', 'Lopez Benitez', '', '', 'gblopez07@gmail.com', 1, 1, '2023-04-12 00:42:59', '2023-04-12 00:42:59'),
(2, 'T00002', 'Yahir', 'Piña', '', '', 'yahirpina@gmail.com', 1, 1, '2023-04-12 00:43:23', '2023-04-12 00:43:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secondname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `state` enum('A','I') COLLATE utf8mb4_unicode_ci DEFAULT 'A',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `firstname`, `secondname`, `lastname`, `username`, `email`, `email_verified_at`, `password`, `file_id`, `remember_token`, `created_by`, `updated_by`, `state`, `created_at`, `updated_at`) VALUES
(1, 'César', 'Yahir', 'Piña', 'Yahir', 'yahirpina@gmail.com', NULL, '$2y$10$njYs/.Yad6Fg5/SNk5/CKeTgAmge9L9dlKQ8RshySgOk.bRGeYVNC', NULL, NULL, 21, 1, 'A', '2022-11-19 06:58:31', '2023-04-12 00:29:37'),
(2, 'Gabriela', '', 'Lopez', 'Gaby', 'gblopez07@gmail.com', NULL, '$2y$10$vylrdAoi.TzHOS79kykt2ejTsmqWY5pmDDCC2arsob2JqRBp4DGCC', NULL, NULL, 1, 1, 'A', '2023-04-12 00:32:39', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_permissions`
--

CREATE TABLE `users_permissions` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_roles`
--

CREATE TABLE `users_roles` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users_roles`
--

INSERT INTO `users_roles` (`user_id`, `role_id`) VALUES
(1, 2),
(2, 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_created_by_index` (`created_by`),
  ADD KEY `categories_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `details_orders`
--
ALTER TABLE `details_orders`
  ADD KEY `details_orders_order_id_foreign` (`order_id`),
  ADD KEY `details_orders_product_id_foreign` (`product_id`);

--
-- Indices de la tabla `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctors_lastname_index` (`lastname`),
  ADD KEY `doctors_rfc_index` (`rfc`),
  ADD KEY `doctors_email_index` (`email`),
  ADD KEY `doctors_created_by_index` (`created_by`),
  ADD KEY `doctors_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `files_created_by_index` (`created_by`),
  ADD KEY `files_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_patient_id_foreign` (`patient_id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_created_by_index` (`created_by`),
  ADD KEY `orders_updated_by_index` (`updated_by`),
  ADD KEY `orders_technical_id_foreign` (`technical_id`);

--
-- Indices de la tabla `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patients_lastname_index` (`lastname`),
  ADD KEY `patients_document_index` (`document`),
  ADD KEY `patients_email_index` (`email`),
  ADD KEY `patients_created_by_index` (`created_by`),
  ADD KEY `patients_updated_by_index` (`updated_by`),
  ADD KEY `orders_doctor_id_foreign` (`doctor_id`);

--
-- Indices de la tabla `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_order_id_foreign` (`order_id`),
  ADD KEY `payments_user_id_foreign` (`created_by`);

--
-- Indices de la tabla `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_categorie_id_foreign` (`categorie_id`),
  ADD KEY `products_created_by_index` (`created_by`),
  ADD KEY `products_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `roles_permissions`
--
ALTER TABLE `roles_permissions`
  ADD KEY `roles_permissions_role_id_foreign` (`role_id`),
  ADD KEY `roles_permissions_permission_id_foreign` (`permission_id`);

--
-- Indices de la tabla `technicals`
--
ALTER TABLE `technicals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `technicals_lastname_index` (`lastname`),
  ADD KEY `technicals_rfc_index` (`rfc`),
  ADD KEY `technicals_email_index` (`email`),
  ADD KEY `technicals_created_by_index` (`created_by`),
  ADD KEY `technicals_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_file_id_foreign` (`file_id`),
  ADD KEY `users_username_index` (`username`),
  ADD KEY `users_created_by_index` (`created_by`),
  ADD KEY `users_updated_by_index` (`updated_by`);

--
-- Indices de la tabla `users_permissions`
--
ALTER TABLE `users_permissions`
  ADD KEY `users_permissions_user_id_foreign` (`user_id`),
  ADD KEY `users_permissions_permission_id_foreign` (`permission_id`);

--
-- Indices de la tabla `users_roles`
--
ALTER TABLE `users_roles`
  ADD KEY `users_roles_user_id_foreign` (`user_id`),
  ADD KEY `users_roles_role_id_foreign` (`role_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `files`
--
ALTER TABLE `files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `patients`
--
ALTER TABLE `patients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `technicals`
--
ALTER TABLE `technicals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `details_orders`
--
ALTER TABLE `details_orders`
  ADD CONSTRAINT `details_orders_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `details_orders_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `orders_technical_id_foreign` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`),
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `orders_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`);

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_categorie_id_foreign` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`);

--
-- Filtros para la tabla `roles_permissions`
--
ALTER TABLE `roles_permissions`
  ADD CONSTRAINT `roles_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `roles_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`);

--
-- Filtros para la tabla `users_permissions`
--
ALTER TABLE `users_permissions`
  ADD CONSTRAINT `users_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `users_permissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `users_roles`
--
ALTER TABLE `users_roles`
  ADD CONSTRAINT `users_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `users_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
