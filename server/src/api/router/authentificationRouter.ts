import AuthentificationController from '../controller/authentificationController';
import abstractRouter from './abstractRouter';

class AuthentificationRouter extends abstractRouter {

    protected Controller: AuthentificationController;

    constructor() {
        super();
        this.Controller = new AuthentificationController();
        this.setupRoutes();
    }

    protected setupRoutes(): void {
        this.router.post('/login', this.Controller.userLogin.bind(this.Controller));
        this.router.post('/register', this.Controller.userRegister.bind(this.Controller));
        this.router.post('/resetPassword', this.Controller.userResetPassword.bind(this.Controller));
        this.router.get('/getUserByToken', this.Controller.getUserByToken.bind(this.Controller));
        this.router.get('/refreshToken', this.Controller.userRefreshToken.bind(this.Controller));
    }

}

export default AuthentificationRouter
