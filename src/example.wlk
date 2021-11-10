class Zona {
	var property valor
	
	method actualizarValor(nuevoValor) {
		valor = nuevoValor
	}
}

object inmobiliaria {
	var property porcentajeDeVenta
	const empleados = #{}
	
	method comisionPorPorcentajeDeVenta(porcentaje) {
		porcentajeDeVenta = porcentaje
	}
	
	method mejorEmpleadoSegun(criterio) = empleados.max({empleado => criterio.ponderacion(empleado)})
}

object totalComisiones {
	method ponderacion(empleado) = empleado.comisionesTotales()
}

object cantOperaciones {
	method ponderacion(empleado) = empleado.operacionesCerradas().size()
}

object cantReservas {
	method ponderacion(empleado) = empleado.reservas().size()
}

class Empleado {
	const property operacionesCerradas = #{}
	const property reservas = #{}
	
	method comisionesTotales() = operacionesCerradas.sum({operacion => operacion.comision()})
	
	method vaATenerProblemas(otroEmpleado) = self.operaronEnLaMismaZona(otroEmpleado) and (self.concretaronMismaOperacion(otroEmpleado) or otroEmpleado.concretaronMismaOperacion(self))
	
	method operaronEnLaMismaZona(otroEmpleado) = self.zonasEnLasQueOpero().any({zona => otroEmpleado.operoEnZona(zona)})
	
	method zonasEnLasQueOpero() = operacionesCerradas.map({operacion => operacion.zona()}).asSet()
	
	method operoEnZona(zona) = self.zonasEnLasQueOpero().contains(zona)
	
	method concretaronMismaOperacion(otroEmpleado) = operacionesCerradas.any({operacion => otroEmpleado.reservo(operacion)})
	
	method reservo(operacion) = reservas.contains(operacion)
	
	method reservarPropiedad(operacion,cliente) {
		operacion.reservarPara(cliente)
		reservas.add(operacion)
	}
	
	method concretarOperacion(operacion,cliente) {
		operacion.concretarPara(cliente)
		operacionesCerradas.add(operacion)
	}
}

class Inmueble {
	var operacion
	const property valor
	const zona
	
	method valor() = self.valorParticular() + zona.valor()
	
	method valorParticular()
}

class Casa inherits Inmueble {
	var valorP
	
	override method valorParticular() = valorP 
}

class PH inherits Inmueble {
	var metroCuadrado
	
	override method valorParticular() = (metroCuadrado * 14000).min(500000)
}

class Departamento inherits Inmueble {
	var ambiente
	
	override method valorParticular() = ambiente * 350000 
}

class Operacion {
	const inmueble
	var estado = disponible
	
	method zona() = inmueble.zona()
	
	method reservarPara(cliente) {
		estado.reservarPara(self,cliente)
	}
}

class Alquiler inherits Operacion {
	const meses
	
	method comision() = (meses * inmueble.valor()) / 50000 
}

class Venta inherits Operacion {
	
	method comision() = inmueble.valor() * (1 * inmobiliaria.porcentajeDeVenta())
}

class EstadoDeOperacion {
	
}

object disponible inherits EstadoDeOperacion {
	
}

class Cliente {
	const nombre
}