"use client";
import {
  Calendar,
  Settings,
  User,
  Users,
  MapPin,
  Award, // Role icon
  Clipboard, // Service icon
} from "lucide-react";

import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";
import { useRouter } from "next/navigation";
import { logout } from "@/lib/server";
import { Button } from "@/components/ui/button";

const items = [
  {
    title: "Calendar",
    url: "#",
    icon: Calendar,
  },
  {
    title: "Customer",
    url: "customer",
    icon: User,
  },
  {
    title: "Team",
    url: "worker",
    icon: Users,
  },
  {
    title: "Location",
    url: "branch",
    icon: MapPin,
  },
  {
    title: "Role",
    url: "role",
    icon: Award,
  },
  {
    title: "Service",
    url: "service",
    icon: Clipboard,
  },
  {
    title: "Settings",
    url: "#",
    icon: Settings,
  },
];

export function AppSidebar() {
  const router = useRouter();
  const handleLogout = () => {
    logout();
    router.push("/login");
  };
  return (
    <Sidebar>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Application</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {items.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild>
                    <a href={item.url}>
                      <item.icon />
                      <span>{item.title}</span>
                    </a>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
              <SidebarMenuItem>
                <SidebarMenuButton asChild>
                  <Button onClick={handleLogout}>logout</Button>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  );
}
