import UserController from '../controller/userController';
import abstractRouter from './abstractRouter';

class UserRouter extends abstractRouter {

    protected Controller: UserController;

    constructor() {
        super();
        this.Controller = new UserController();
        this.setupRoutes();
    }

    protected setupRoutes(): void {
        this.router.delete('/', this.checkAuth, this.Controller.userDelete.bind(this.Controller));
        this.router.patch('/', this.checkAuth, this.Controller.userPatch.bind(this.Controller));
    }

}

export default UserRouter