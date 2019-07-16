mostrar db's

	show dbs

criar db (apenas refencia, so cria depois de inserido alguma coleção)

	use queue_data

mostra o db atual

	db

criar uma colecao chamada queue_data

	a = {nome:'mycompany', fila:[], status: 0}
	db.queue_data.save(a)
ou

	db.queue_data.insert({nome:'mycompany', fila:[], status: 0})


listar toda a coleção

	db.queue_data.find()

dropar uma colecao

	db.queue_data.drop()

remover uma colecao

	db.queue_data.remove()


insere novo elemento no array dentro da colecao

	nova = {_id:ObjectId(), nome:"reconhecimento", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}
	db.queue_data.update({"_id" : ObjectId("5ad95167cd8ac6079b905cc4")},{$push:{fila:nova}})

ou

	db.queue_data.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$push:{fila:{_id:ObjectId(), nome:"entrada", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}}})

listar padrao humano

	db.queue_data.find().pretty()

remove um elemento do array dentro da colecao

	db.queue_data.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$pull:{fila:{nome:"entrada"}}})

procura por transferencia nas filas

	db.queue_data.find({_id:ObjectId("5ad95167cd8ac6079b905cc4")},{fila:{$elemMatch:{"nome" : "transferencia"}}}).pretty()
