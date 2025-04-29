const express = require("express");
const mysql = require("mysql2");
const app = express();

app.use(express.static('public'));

const connection = mysql.createConnection({
    host: 'localhost', //endereço do banco de dados
    user: 'root', //nome do usuario do banco
    password: 'Dani090707*', // senha do banco
    database: 'Condominio', // nome do banco
    port: 3306 // porta do banco
});

connection.connect(function(err){
    if(err){
        console.error("ERRO ", err);
        return
    } console.log("Conexão ok! ")
});

app.listen(8083, function(){
console.log("Servidor rodando na URL http://localhost:8083")
});

app.get("/", function(req, res){
    const select = "Select * from bloco"

    connection.query(select, function(err, rows){
        if (!err){
            res.send(`
                <!DOCTYPE html>
                        <html lang="pt-br">
                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Gerenciamento de blocos</title>
                        </head>
                        <body>
                            <h1>Condomínio</h1>

                            <h2>Pesquisar bloco</h2>
                            <input type="text" name="pesquisa" placeholder="ex: bloco A" >

                            <table>
                            <tr>
                                <th>descrição</th>
                                <th>Qtd de apartamentos</th>
                                <th>ações</th>
                            </tr>

                            ${rows.map(row => `
                                <tr>
                                    <td>${row.descricao}</td>
                                    <td>${row.qtdApartamentos}</td>
                                    <td><a href="/excluir/${row.idbloco}">Excluir</a>
                                        <a href="/editar/${row.idbloco}">Editar</a></td>
                                </tr>
                                </tr>
                                `).join('')}
                        </table>
                        <a href='/'> Voltar </a>
    
                        </body>
                        </html>
                    `)
        }
    })

});

app.get("/listaBlocos", function(req, res){
    
});

app.get("/excluir/:idbloco", function(req, res){
    const idbloco = req.params.idbloco;

    const excluir = "DELETE FROM bloco where idbloco = ?" 

    connection.query(excluir, [idbloco], function(err, result){
        if(err){
            console.error("Erro ao excluir o produto: ", err);
            res.status(500).send('Erro interno ao excluir o produto.');
            return;
        }

        
        console.log("Produto excluido com sucesso!");
        res.redirect('/');
    })

});



