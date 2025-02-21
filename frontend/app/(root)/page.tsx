"use client";
import Image from "next/image";
import Login from "@/components/Login";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { logout } from "@/lib/server";
import { useRouter } from "next/navigation";
export default function Home() {
  const router = useRouter();
  const handleLogout = () => {
    logout();
    router.push("/login");
  };
  return <div></div>;
}
