import { PrismaClient } from "@prisma/client";

class abstractMiddleware {
    protected prisma: PrismaClient;

    constructor() {
        this.prisma = new PrismaClient();
    }


}

export default abstractMiddleware;