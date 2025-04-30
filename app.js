const express = require("express");
const mysql = require("mysql2");
const app = express();
const bodyParser = require("body-parser")

app.use(express.static('public'));
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());
app.use(express.urlencoded({extended:true}));

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

// Consulta de Bloco

app.get("/cadastroBloco", function(req, res){
    res.render("create")
});

app.get("/edit/:idbloco", function(req, res){
    const idbloco = req.params.idbloco;
    const query = 'SELECT * FROM Bloco WHERE idbloco = ?';

    connection.query(query, [idbloco], (err, results) => {
        if (err) return res.status(500).send('Erro ao buscar o bloco');
        if (results.length === 0) return res.status(404).send('Bloco não encontrado');

        res.render('edit', { bloco: results[0] });
    });
});

app.get("/", function(req, res){
    const select = "Select * from Bloco"

    connection.query(select, function(err, results){
        if (err){
            return res.status(500).send('Erro ao buscar dados')
        }

        res.render("index", { rows: results })
    });

});

app.get("/delete/:idbloco", function(req, res){
    const idbloco = req.params.idbloco;

    const excluir = "DELETE FROM Bloco where idbloco = ?" 

    connection.query(excluir, [idbloco], function(err, result){
        if(err){
            console.error("Erro ao excluir o bloco: ", err);
            res.status(500).send('Erro interno ao excluir o bloco.');
            return;
        }

        
        console.log("Bloco excluido com sucesso!");
        res.redirect('/');
    });

});

app.post("/search", function(req, res){
    const search = req.body.pesquisa
    const query = "SELECT * FROM Bloco where descricao = ?"

    connection.query(query, [search], function(err, results){
        if(err){
            return res.status(500).send('Erro ao buscar dados')
        }if(results.length === 0){
            return res.status(404).send(`
                <!DOCTYPE html>
                <html lang="pt-br">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Bloco não existentente</title>
                    <link rel="stylesheet" href="/style.css">

                </head>
                <h1>Bloco não existente</h1>
                <h2>Insira um bloco válido</h2>

                <a href="/" >Voltar</a>
                </html>
                `
            )}
        res.render("index", { rows: results })
    });


});

app.post("/create", function(req, res){
    const descricao = req.body.descricao
    const qtdApt = req.body.qtdApt

    const create = "INSERT INTO bloco (descricao, qtdApt) VALUES (?, ?)"

    connection.query(create, [descricao, qtdApt], function(err, results){
        if (err) {
            console.log("Não foi possível inserir os dados:", err);
            return res.send(`
                <html>
                <h1>ERRO</h1>
                <h2>Bloco ja existente. Por favor, crie um bloco não existente!<h2>
                <a href="/cadastroBloco">Voltar</a>
                </html>
                `);
        }

        console.log("Dados inseridos com sucesso");
        res.redirect("/");
    });
});



app.post("/edit/:idbloco", function(req, res){
    const idbloco = req.params.idbloco;
    const descricao = req.body.descricao;
    const qtdApt = req.body.qtdApt;

    const update = "UPDATE bloco SET descricao = ?, qtdApt = ? WHERE idbloco = ?";
 
    connection.query(update, [descricao, qtdApt, idbloco], function(err, result){
        if(!err){
            console.log("Bloco editado com sucesso!");
            res.redirect('/'); 
        }else{
            console.log("Erro ao editar o bloco ", err);
            res.send("Erro")
        }
    });
}); 

// Consulta de apartamentos

app.get("/apartment", function(req, res){
    const select = "SELECT b.descricao, a.numeroApt FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco"

    connection.query(select, function(err, results){
        if (err){
            return res.status(500).send('Erro ao buscar dados')
        }

        res.render("apartment", { rows: results })
    });

});

app.post("/searchApt", function(req, res){
    const search = req.body.pesquisa
    const query = "SELECT b.descricao, a.numeroApt FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco where numeroApt = ?"

    connection.query(query, [search], function(err, results){
        if(err){
            return res.status(500).send('Erro ao buscar dados')
        }if(results.length === 0){
            return res.status(404).send(`
                <!DOCTYPE html>
                <html lang="pt-br">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Apartamento não existentente</title>
                    <link rel="stylesheet" href="/style.css">

                </head>
                <h1>Apartamento não existente</h1>
                <h2>Insira um apartamento válido</h2>

                <a href="/apartment" >Voltar</a>
                </html>
                `
    )}

        res.render("apartment", { rows: results })
    });


});


app.listen(8083, function(){
    console.log("Servidor rodando na URL http://localhost:8083")
    });