import ImageController from '../controller/imageController'
import AbstractRouter from './abstractRouter'

export default class ImageRouter extends AbstractRouter {
    protected Controller: ImageController
    
    constructor() {
        super()
        this.Controller = new ImageController()
        this.setupRoutes()
    }
    
    protected setupRoutes(): void {
        this.router.get(
        '/:id',
        this.Controller.imageGet.bind(this.Controller)
        )
    }
}