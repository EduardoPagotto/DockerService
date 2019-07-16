mostrar db's

	show dbs

criar db (apenas refencia, so cria depois de inserido alguma coleção)

	use nsqueue

mostra o db atual

	db

criar uma colecao chamada nsqueue

	a = {nome:'namespace', fila:[], status: 0}
	db.nsqueue.save(a)
ou

	db.nsqueue.insert({nome:'namespace', fila:[], status: 0})


listar toda a coleção

	db.nsqueue.find()

dropar uma colecao

	db.nsqueue.drop()

remover uma colecao

	db.nsqueue.remove()


insere novo elemento no array dentro da colecao

	nova = {_id:ObjectId(), nome:"reconhecimento", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}
	db.nsqueue.update({"_id" : ObjectId("5ad95167cd8ac6079b905cc4")},{$push:{fila:nova}})

ou

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$push:{fila:{_id:ObjectId(), nome:"entrada", status:0, tipo:"FIFO", ttl:0, sla:0, prioridade:0}}})

listar padrao humano

	db.nsqueue.find().pretty()

remove um elemento do array dentro da colecao

	db.nsqueue.update({"_id" : ObjectId("5ad94bcdcd8ac6079b905cc1")},{$pull:{fila:{nome:"entrada"}}})

procura por transferencia nas filas

	db.nsqueue.find({_id:ObjectId("5ad95167cd8ac6079b905cc4")},{fila:{$elemMatch:{"nome" : "transferencia"}}}).pretty()
