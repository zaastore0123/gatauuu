const express = require('express');
const multer = require('multer');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const app = express();
app.use(express.json());

const upload = multer({ dest: 'uploads/' });

function auth(req,res,next){
  const h = req.headers.authorization;
  if(!h) return res.status(401).send('Unauthorized');
  const token = h.split(' ')[1];
  try{
    const payload = jwt.verify(token, process.env.JWT_SECRET || 'SECRET_KEY');
    req.user = payload;
    next();
  }catch(e){
    res.status(401).send('Invalid token');
  }
}

app.post('/api/auth/login', (req,res)=>{
  const { email } = req.body;
  const token = jwt.sign({ email, role:'uploader' }, process.env.JWT_SECRET || 'SECRET_KEY', { expiresIn:'1h' });
  res.json({ token });
});

app.post('/api/scripts/:id/upload', auth, upload.single('file'), (req,res)=>{
  const file = req.file;
  if(!file) return res.status(400).send('No file');
  res.json({ success:true, file:{ originalname:file.originalname, path:file.path }});
});

app.get('/api/scripts/:id/versions/:vid/download', (req,res)=>{
  const filePath = path.join(__dirname, 'uploads', 'example.zip');
  if(!fs.existsSync(filePath)) return res.status(404).send('Not found');
  res.download(filePath, 'script.zip');
});

app.listen(3000, ()=>console.log('🚀 Backend running on http://localhost:3000'));