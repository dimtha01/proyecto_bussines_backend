import { Router } from "express";
import { getProfile, login , register} from "./auth.controller.js";
import { validateLogin, validateRegister } from "./auth.validators.js";
import { protect } from "../../middleware/auth.middleware.js";
const router = Router();

router.post("/login", validateLogin, login);

router.post("/register", validateRegister, register);

router.get("/profile", protect, getProfile);


export default router;