import pg = require('pg');
import Database from './../../database';

abstract class AbstractController {
    
    protected database: Database;
    protected pool: pg.Pool;
    
    constructor() {
        this.database = new Database();
        this.pool = this.database.getPool();
    }

}

export default AbstractController