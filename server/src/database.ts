import pg from "pg";

class Database {
  private pool: pg.Pool;
  private static instance: Database;

  private dbConfig: pg.PoolConfig = {
    user: process.env.PG_USER,
    host: process.env.PG_HOST,
    database: process.env.PG_DATABASE,
    password: process.env.PG_PASSWORD,
    port: parseInt(process.env.PG_PORT),
  };

  constructor() {
    if (!Database.instance) {
      this.createPool();
      Database.instance = this;
    }
    return Database.instance;
  }

  private createPool() {
    try {
      this.pool = new pg.Pool(this.dbConfig);
    } catch (error) {
      console.error("Fehler beim Erstellen des Pools:", error);
    }
  }

  public getPool(): pg.Pool {
    return this.pool;
  }
}

export default Database;
