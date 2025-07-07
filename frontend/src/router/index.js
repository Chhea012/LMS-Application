import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import DepartmentView from "../views/DepartmentView.vue";
import UserView from "../views/UserView.vue";
import RequestView from "../views/permission/RequestView.vue";
import TypeView from "../views/permission/TypeView.vue";
import ApprovalView from "../views/permission/ApprovalView.vue";
import ProfileSettingView from "@/views/profile/ProfileSettingView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView,
    },
    {
      path: "/department",
      name: "department",
      component: DepartmentView,
    },
    {
      path: "/user",
      name: "user",
      component: UserView,
    },
    {
      path: "/permission/request",
      name: "request",
      component: RequestView,
    },
    {
      path: "/permission/type",
      name: "type",
      component: TypeView,
    },
    {
      path: "/permission/approval",
      name: "approval",
      component: ApprovalView,
    },
    {
      path: "/profile-settings",
      name: "ProfileSettings",
      component: ProfileSettingView,
    },
  ],
});

export default router;
