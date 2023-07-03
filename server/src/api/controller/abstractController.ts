import pg = require('pg');
import Database from './../../database';
import { PrismaClient } from '@prisma/client'
import firebase = require("firebase/app");
import firebaseAdmin = require("firebase-admin");
import firebaseAuth = require("firebase/auth");

abstract class AbstractController {
    
    private firebaseConfig = {
        apiKey: process.env.FB_API_KEY,
        authDomain: process.env.FB_AUTH_DOMAIN,
        databaseURL: process.env.FB_DATABASE_URL,
        projectId: process.env.FB_PROJECT_ID,
        storageBucket: process.env.FB_STORAGE_BUCKET,
        messagingSenderId: process.env.FB_MESSAGING_SENDER_ID,
        appId: process.env.FB_APP_ID,
    };

    protected firebaseAdmin = firebaseAdmin;
    protected firebaseAuth = firebaseAuth;
    protected auth: firebaseAuth.Auth;
    protected database: Database;
    protected pool: pg.Pool;
    protected prisma: PrismaClient;
    
    constructor() {
        this.database = new Database();
        this.pool = this.database.getPool();
        this.prisma = new PrismaClient();
        firebase.initializeApp(this.firebaseConfig);
        this.auth = firebaseAuth.getAuth();
    }
    


}

export default AbstractController