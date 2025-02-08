class_name  BarraSalud extends ProgressBar



func actualizar_barra(maximo:float,  actual:float):
	self.value = actual/ maximo * 1.0


#var valor_target : = 0.0
#
#func _process(delta):
	#if valor_target > 0.0:
		#var aux 
		#aux = move_toward(self.value, valor_target,delta * 0.9 ) 
		#self.value = aux
#
#func actualizar_barra(maximo:float,  actual:float):
	#valor_target = actual/ maximo
