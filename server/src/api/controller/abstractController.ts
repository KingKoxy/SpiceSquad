import pg = require('pg');
import Database from './../../database';
import { PrismaClient } from '@prisma/client'

abstract class AbstractController {
    
    protected database: Database;
    protected pool: pg.Pool;
    protected prisma: PrismaClient;
    
    constructor() {
        this.database = new Database();
        this.pool = this.database.getPool();
        this.prisma = new PrismaClient();
    }
    


}

export default AbstractController