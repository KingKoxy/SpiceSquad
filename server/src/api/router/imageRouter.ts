import ImageController from '../controller/imageController'
import AbstractRouter from './abstractRouter'
import { imageGetSchema, imagePatchSchema, imagePostSchema } from '../../schemas/imageSchema'

export default class ImageRouter extends AbstractRouter {
  protected Controller: ImageController

  constructor() {
    super()
    this.Controller = new ImageController()
    this.setupRoutes()
  }

  protected setupRoutes(): void {
    this.router.get(
      '/:imageId',
      this.schemaValidator.checkSchema(imageGetSchema),
      this.Controller.imageGet.bind(this.Controller)
    )
    this.router.post(
      '/',
      this.checkAuth,
      this.schemaValidator.checkSchema(imagePostSchema),
      this.Controller.imagePost.bind(this.Controller)
    )
    this.router.patch(
      '/:imageId',
      this.checkAuth,
      this.schemaValidator.checkSchema(imagePatchSchema),
      this.Controller.imagePatch.bind(this.Controller)
    )
  }
}
